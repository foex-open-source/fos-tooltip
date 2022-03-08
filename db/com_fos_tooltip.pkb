create or replace package body com_fos_tooltip
as

-- =============================================================================
--
--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)
--
--  This plug-in provides you with a Tooltip dynamic action.
--
--  License: MIT
--
--  GitHub: https://github.com/foex-open-source/fos-tooltip
--
-- =============================================================================

G_C_ATTR_ID_1                  constant varchar2(100)             := 'G_FOS_TOOLTIP_ATTR_1';
G_C_ATTR_ID_2                  constant varchar2(100)             := 'G_FOS_TOOLTIP_ATTR_2';
G_C_ATTR_ID_3                  constant varchar2(100)             := 'G_FOS_TOOLTIP_ATTR_3';
G_IN_ERROR_HANDLING_CALLBACK   boolean                            := false                 ;

--------------------------------------------------------------------------------
-- private function to include the apex error handling function, if one is
-- defined on application or page level
--------------------------------------------------------------------------------
function error_function_callback
  ( p_error in apex_error.t_error
  )  return apex_error.t_error_result
is
    c_cr constant varchar2(1) := chr(10);

    l_error_handling_function apex_application_pages.error_handling_function%type;
    l_statement               varchar2(32767);
    l_result                  apex_error.t_error_result;

    procedure log_value
      ( p_attribute_name in varchar2
      , p_old_value      in varchar2
      , p_new_value      in varchar2
      )
    is
    begin
        if   p_old_value <> p_new_value
          or (p_old_value is not null and p_new_value is null)
          or (p_old_value is null     and p_new_value is not null)
        then
            apex_debug.info('%s: %s', p_attribute_name, p_new_value);
        end if;
    end log_value;

begin
    if not g_in_error_handling_callback
    then
        g_in_error_handling_callback := true;

        begin
            select /*+ result_cache */
                   coalesce(p.error_handling_function, f.error_handling_function)
              into l_error_handling_function
              from apex_applications f,
                   apex_application_pages p
             where f.application_id     = apex_application.g_flow_id
               and p.application_id (+) = f.application_id
               and p.page_id        (+) = apex_application.g_flow_step_id;
        exception when no_data_found then
            null;
        end;
    end if;

    if l_error_handling_function is not null
    then
        l_statement := 'declare'||c_cr||
                           'l_error apex_error.t_error;'||c_cr||
                       'begin'||c_cr||
                           'l_error := apex_error.g_error;'||c_cr||
                           'apex_error.g_error_result := '||l_error_handling_function||' ('||c_cr||
                               'p_error => l_error );'||c_cr||
                       'end;';

        apex_error.g_error := p_error;

        begin
            apex_exec.execute_plsql(l_statement);
        exception when others then
            apex_debug.error('error in error handler: %s', sqlerrm);
            apex_debug.error('backtrace: %s', dbms_utility.format_error_backtrace);
        end;

        l_result := apex_error.g_error_result;

        if l_result.message is null
        then
            l_result.message          := nvl(l_result.message,          p_error.message);
            l_result.additional_info  := nvl(l_result.additional_info,  p_error.additional_info);
            l_result.display_location := nvl(l_result.display_location, p_error.display_location);
            l_result.page_item_name   := nvl(l_result.page_item_name,   p_error.page_item_name);
            l_result.column_alias     := nvl(l_result.column_alias,     p_error.column_alias);
        end if;
    else
        l_result.message          := p_error.message;
        l_result.additional_info  := p_error.additional_info;
        l_result.display_location := p_error.display_location;
        l_result.page_item_name   := p_error.page_item_name;
        l_result.column_alias     := p_error.column_alias;
    end if;

    if l_result.message = l_result.additional_info
    then
        l_result.additional_info := null;
    end if;

    g_in_error_handling_callback := false;

    return l_result;

exception
    when others then
        l_result.message             := 'custom apex error handling function failed !!';
        l_result.additional_info     := null;
        l_result.display_location    := apex_error.c_on_error_page;
        l_result.page_item_name      := null;
        l_result.column_alias        := null;
        g_in_error_handling_callback := false;

        return l_result;
end error_function_callback;

--------------------------------------------------------------------------------
-- checks if a given item name exists in the application as page or app item
--------------------------------------------------------------------------------
function item_exists
    ( p_item_name      in varchar2
    ) return boolean
is
    l_exists        boolean := false;
begin

    for c in
    ( select distinct null
      from   (  select /*+ result_cache */
                       null
                from   apex_application_items
                where  application_id   = wwv_flow.g_flow_id
                and    item_name        = p_item_name
              )
    ) loop
        l_exists := true;
        exit;
    end loop;

  return l_exists;

end item_exists;

------------------------------------------------------------------------------
-- We need to use application items within our source query for filtering
-- as we execute the SQL with apex_plugin_util, which has no means
-- of passing in values however it repalces binds of existing
-- application/page items
------------------------------------------------------------------------------
procedure application_item_check
    ( p_item_names apex_t_varchar2
    )
as
    l_exists            varchar2(10);
begin

    for i in 1.. p_item_names.count
    loop
        if p_item_names(i) is not null
        then

            if not item_exists(p_item_names(i))
            then
                --
                -- Application item does not exist so lets create it
                --
                --apex_debug.trace('Creating a new application item: %s for the FOEX Scheduler Plug-in',l_item_names(i));

                wwv_flow_api.create_flow_item
                    ( p_flow_id          => wwv_flow.g_flow_id
                    , p_name             => p_item_names(i)
                    , p_data_type        => 'VARCHAR'
                    , p_is_persistent    => 'Y'
                    , p_protection_level => 'I'
                    , p_item_comment     => 'This item is used for the FOS - Tooltip Plug-in'
                    );

            end if;
        end if;
    end loop;

end application_item_check;

-- function to check if the app is in dev-mode
function is_developer_session
return boolean
as
begin
    return (coalesce(apex_application.g_edit_cookie_session_id, v('APP_BUILDER_SESSION')) is not null);
end is_developer_session;

function render
  ( p_dynamic_action in apex_plugin.t_dynamic_action
  , p_plugin         in apex_plugin.t_plugin
  )
return apex_plugin.t_dynamic_action_render_result
as
    l_result             apex_plugin.t_dynamic_action_render_result;
    l_id                 p_dynamic_action.id%type           := p_dynamic_action.id;
    -- ajax identifier
    l_ajax_id            l_result.ajax_identifier%type      := apex_plugin.get_ajax_identifier;
    -- init js
    l_init_js_fn         varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), 'undefined');

    --attributes
    l_loading_text       p_plugin.attribute_01%type         := p_plugin.attribute_01;
    l_no_data_text       p_plugin.attribute_02%type         := p_plugin.attribute_02;
    l_src                p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_sql_src            p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    l_items_to_submit    p_dynamic_action.attribute_03%type := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_03);
    l_attr_to_submit     p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
    l_static_src         p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;
    l_attr_src           p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;
    l_plsql_src          p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;
    l_bg_color           p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;
    l_txt_color          p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;
    l_animation          p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;
    l_duration           p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_11;
    l_display_on         p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;
    l_placement          p_dynamic_action.attribute_13%type := p_dynamic_action.attribute_13;
    l_options            p_dynamic_action.attribute_14%type := p_dynamic_action.attribute_14;

    l_follow_cursor      boolean                            := instr(l_options, 'follow-cursor'   ) > 0;
    l_interactive_text   boolean                            := instr(l_options, 'interactive-text') > 0;
    l_disable_arrow      boolean                            := instr(l_options, 'disable-arrow'   ) > 0;
    l_escape_html        boolean                            := instr(l_options, 'escape-html'     ) > 0;
    l_cache              boolean                            := instr(l_options, 'cache-result'    ) > 0;
    l_show_on_create     boolean                            := instr(l_options, 'show-on-create'  ) > 0;

    l_items_to_submit_$  varchar2(32000);
    l_content            varchar2(32767);

    l_theme_name         varchar2(1000)                     := 'fos-tooltip-theme-' || l_id;
    l_app_items          apex_t_varchar2                    := apex_t_varchar2(G_C_ATTR_ID_1, G_C_ATTR_ID_2, G_C_ATTR_ID_3);
    l_exists             boolean                            := false;

    l_rt_api_usage       varchar2(100);
    l_error_msg          varchar2(1000);

begin

    --debug
    if apex_application.g_debug and substr(:DEBUG,6) >= 6
    then
        apex_plugin_util.debug_dynamic_action
          ( p_plugin         => p_plugin
          , p_dynamic_action => p_dynamic_action
          );
    end if;

    --add css file for the choosen animation
    apex_css.add_file
       ( p_name       => l_animation
       , p_directory  => p_plugin.file_prefix || 'css/'
       );

    --add style to the tooltips
    apex_css.add
        ( p_css => '.tippy-box[data-theme~="'|| l_theme_name ||'"] { background-color:' || l_bg_color || '; color:' || l_txt_color || '; }'
                || '.tippy-box[data-theme~="'|| l_theme_name ||'"] .tippy-arrow { color: ' || l_bg_color || '; }'
        , p_key => 'tippy-box-' || l_theme_name
        );

    if (l_src = 'sql' or l_src = 'plsql') and is_developer_session
    then
        for i in 1 .. l_app_items.count
        loop
            l_exists := item_exists(l_app_items(i));
        end loop;

        if not l_exists
        then
            select runtime_api_usage into l_rt_api_usage from apex_applications where application_id = :APP_ID;

            if instr(l_rt_api_usage, 'T') > 0
            then
                application_item_check
                    ( p_item_names => l_app_items
                    );
            else
                l_error_msg := 'FOS - Tooltip: For full SQL / PL/SQL support some specific application items have to be created. Set the "Runtime API Usage" application attribute to "This application" and run the application once.';
            end if;
       end if;
    end if;

    if l_src = 'static'
    then
        l_content := apex_plugin_util.replace_substitutions
            ( p_value => l_static_src
            , p_escape => l_escape_html
            );
    end if;

    apex_json.initialize_clob_output;

    apex_json.open_object;

    apex_json.write('ajaxId'         , l_ajax_id            );
    apex_json.write('src'            , l_src                );
    apex_json.write('itemsToSubmit'  , l_items_to_submit    , true);
    apex_json.write('attrToSubmit'   , l_attr_to_submit     , true);
    apex_json.write('staticSrc'      , l_static_src         );
    apex_json.write('content'        , l_content            );
    apex_json.write('attrSrc'        , l_attr_src           );
    apex_json.write('escapeHTML'     , l_escape_html        );
    apex_json.write('bgColor'        , l_bg_color           );
    apex_json.write('txtColor'       , l_txt_color          );
    apex_json.write('animation'      , l_animation          );
    apex_json.write('duration'       , l_duration           );
    apex_json.write('displayOn'      , l_display_on         );
    apex_json.write('placement'      , l_placement          );
    apex_json.write('theme'          , l_theme_name         );
    apex_json.write('disableArrow'   , l_disable_arrow      );
    apex_json.write('interactiveText', l_interactive_text   );
    apex_json.write('followCursor'   , l_follow_cursor      );
    apex_json.write('errorMsg'       , l_error_msg          );
    apex_json.write('cacheResult'    , l_cache              );
    apex_json.write('loadingText'    , l_loading_text       );
    apex_json.write('noDataFoundText', l_no_data_text       );
    apex_json.write('showOnCreate'   , l_show_on_create     );

    apex_json.close_object;

    l_result.javascript_function := 'function(){FOS.utils.tooltip.init(this, ' ||  apex_json.get_clob_output || ', ' || l_init_js_fn ||');}';

    apex_json.free_output;

    return l_result;
end render;

function ajax
  ( p_dynamic_action in apex_plugin.t_dynamic_action
  , p_plugin         in apex_plugin.t_plugin
  )
return apex_plugin.t_dynamic_action_ajax_result
as
    l_return                 apex_plugin.t_dynamic_action_ajax_result;
    l_context                apex_exec.t_context;
    l_parameters             apex_exec.t_parameters;

    -- error handling
    l_apex_error             apex_error.t_error;
    l_result                 apex_error.t_error_result;

    l_fos_tooltip_attr_id_1  varchar2(1000)                     := apex_application.g_x01;
    l_fos_tooltip_attr_id_2  varchar2(1000)                     := apex_application.g_x02;
    l_fos_tooltip_attr_id_3  varchar2(1000)                     := apex_application.g_x03;

    c_too_many_cols          constant number                    := -20001;
    c_too_many_rows          constant number                    := -20002;

    l_source                 p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    l_sql_source             p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    l_plsql_source           p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;
    l_html_expr              p_dynamic_action.attribute_15%type := p_dynamic_action.attribute_15;

    l_col_count              number;
    l_col                    apex_exec.t_column;
    l_tooltip_result         varchar2(32767);
    l_message                varchar2(32767);

    l_app_items              apex_t_varchar2                    := apex_t_varchar2(G_C_ATTR_ID_1, G_C_ATTR_ID_2, G_C_ATTR_ID_3);
    l_app_attr               apex_t_varchar2                    := apex_t_varchar2(l_fos_tooltip_attr_id_1, l_fos_tooltip_attr_id_2, l_fos_tooltip_attr_id_3);

    function escape_html
      ( p_html                   in varchar2
      , p_escape_already_enabled in boolean
      ) return varchar2
    is
    begin
        return case when p_escape_already_enabled then p_html else apex_escape.html(p_html) end;
    end escape_html;

begin

    --debug
    if apex_application.g_debug and substr(:DEBUG,6) >= 6
    then
        apex_plugin_util.debug_dynamic_action
          ( p_plugin         => p_plugin
          , p_dynamic_action => p_dynamic_action
          );
    end if;

    if l_source = 'sql' or l_source = 'plsql'
    then
        for i in 1 .. l_app_items.count
        loop
            if item_exists(l_app_items(i))
            then
                apex_util.set_session_state(l_app_items(i),l_app_attr(i));
            end if;
        end loop;
    end if;

    if l_source = 'sql'
    then
        l_context := apex_exec.open_query_context
            ( p_location        => apex_exec.c_location_local_db
            , p_sql_query       => l_sql_source
            , p_max_rows        => 1
            );

        l_col_count := apex_exec.get_column_count(l_context);

        if l_html_expr is null and l_col_count > 1
        then
            raise_application_error(c_too_many_cols, 'Too many columns');
        end if;

        if apex_exec.get_total_row_count(l_context) > 1
        then
            raise_application_error(c_too_many_rows, 'Too many rows');
        end if;

        while apex_exec.next_row(l_context)
        loop
            if l_html_expr is not null
            then
                for i in 1 .. l_col_count
                loop
                    l_col := apex_exec.get_column(l_context,i);
                    l_html_expr := replace(l_html_expr,'#'|| l_col.name ||'#',apex_exec.get_varchar2(l_context,i));
                end loop;
                l_tooltip_result := l_html_expr;
            else
                l_tooltip_result := apex_exec.get_varchar2(l_context,1);
            end if;
        end loop;

        apex_exec.close(l_context);

    elsif l_source = 'plsql'
    then
        l_tooltip_result := apex_plugin_util.get_plsql_function_result
            ( p_plsql_function => l_plsql_source
            );
    end if;

    apex_json.open_object;
    apex_json.write('success', true            );
    apex_json.write('src'    , l_tooltip_result);
    apex_json.close_object;

    return l_return;

exception
    when others then

        l_message := coalesce(apex_application.g_x01, sqlerrm);
        l_message := replace(l_message, '#SQLCODE#', escape_html(sqlcode, true));
        l_message := replace(l_message, '#SQLERRM#', escape_html(sqlerrm, true));
        l_message := replace(l_message, '#SQLERRM_TEXT#', escape_html(substr(sqlerrm, instr(sqlerrm, ':')+1), true));

        apex_json.initialize_output;
        l_apex_error.message             := l_message;
        l_apex_error.ora_sqlcode         := sqlcode;
        l_apex_error.ora_sqlerrm         := sqlerrm;
        l_apex_error.error_backtrace     := dbms_utility.format_error_backtrace;

        l_result := error_function_callback(l_apex_error);

        apex_json.open_object;
        apex_json.write('status' , 'error');
        apex_json.write('success', false);

        case SQLCODE
            when c_too_many_rows then
                apex_json.write('errMsg', 'Too many rows returned, expected only one');
            when c_too_many_cols then
                apex_json.write('errMsg', 'Too many columns selected, only one is allowed');
            else
                apex_json.write('errMsg', SQLERRM);
        end case;

        apex_json.close_object;
        sys.htp.p(apex_json.get_clob_output);
        apex_json.free_output;

        return l_return;
end ajax;


end;
/


