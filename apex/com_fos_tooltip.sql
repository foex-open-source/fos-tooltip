prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_190200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2019.10.04'
,p_release=>'19.2.0.00.18'
,p_default_workspace_id=>1620873114056663
,p_default_application_id=>102
,p_default_id_offset=>0
,p_default_owner=>'FOS_MASTER_WS'
);
end;
/

prompt APPLICATION 102 - FOS Dev - Plugin Master
--
-- Application Export:
--   Application:     102
--   Name:            FOS Dev - Plugin Master
--   Exported By:     FOS_MASTER_WS
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 61118001090994374
--     PLUGIN: 134108205512926532
--     PLUGIN: 1039471776506160903
--     PLUGIN: 547902228942303344
--     PLUGIN: 217651153971039957
--     PLUGIN: 412155278231616931
--     PLUGIN: 1389837954374630576
--     PLUGIN: 461352325906078083
--     PLUGIN: 13235263798301758
--     PLUGIN: 216426771609128043
--     PLUGIN: 37441962356114799
--     PLUGIN: 1846579882179407086
--     PLUGIN: 8354320589762683
--     PLUGIN: 50031193176975232
--     PLUGIN: 106296184223956059
--     PLUGIN: 35822631205839510
--     PLUGIN: 2674568769566617
--     PLUGIN: 183507938916453268
--     PLUGIN: 14934236679644451
--     PLUGIN: 2600618193722136
--     PLUGIN: 2657630155025963
--     PLUGIN: 284978227819945411
--     PLUGIN: 56714461465893111
--     PLUGIN: 98648032013264649
--     PLUGIN: 455014954654760331
--     PLUGIN: 98504124924145200
--     PLUGIN: 212503470416800524
--   Manifest End
--   Version:         19.2.0.00.18
--   Instance ID:     250144500186934
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_fos_tooltip
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(212503470416800524)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.FOS.TOOLTIP'
,p_display_name=>'FOS - Tooltip'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#js/script#MIN#.js',
'#PLUGIN_FILES#libraries/popper/popper.min.js',
'#PLUGIN_FILES#libraries/tippy/tippy-bundle.umd.min.js',
'',
''))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#libraries/tippy/css/tippy.css',
'#PLUGIN_FILES#css/border.css'))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- =============================================================================',
'--',
'--  FOS = FOEX Open Source (fos.world), by FOEX GmbH, Austria (www.foex.at)',
'--',
'--  This plug-in provides you with a Tooltip dynamic action.',
'--',
'--  License: MIT',
'--',
'--  GitHub: https://github.com/foex-open-source/fos-tooltip',
'--',
'-- =============================================================================',
'',
'G_C_ATTR_ID_1                  constant varchar2(100)             := ''G_FOS_TOOLTIP_ATTR_1'';',
'G_C_ATTR_ID_2                  constant varchar2(100)             := ''G_FOS_TOOLTIP_ATTR_2'';',
'G_C_ATTR_ID_3                  constant varchar2(100)             := ''G_FOS_TOOLTIP_ATTR_3'';',
'G_IN_ERROR_HANDLING_CALLBACK   boolean                            := false                 ;',
'',
'--------------------------------------------------------------------------------',
'-- private function to include the apex error handling function, if one is',
'-- defined on application or page level',
'--------------------------------------------------------------------------------',
'function error_function_callback',
'  ( p_error in apex_error.t_error',
'  )  return apex_error.t_error_result',
'is',
'    c_cr constant varchar2(1) := chr(10);',
'',
'    l_error_handling_function apex_application_pages.error_handling_function%type;',
'    l_statement               varchar2(32767);',
'    l_result                  apex_error.t_error_result;',
'',
'    procedure log_value',
'      ( p_attribute_name in varchar2',
'      , p_old_value      in varchar2',
'      , p_new_value      in varchar2 ',
'      )',
'    is',
'    begin',
'        if   p_old_value <> p_new_value',
'          or (p_old_value is not null and p_new_value is null)',
'          or (p_old_value is null     and p_new_value is not null)',
'        then',
'            apex_debug.info(''%s: %s'', p_attribute_name, p_new_value);',
'        end if;',
'    end log_value;',
'',
'begin',
'    if not g_in_error_handling_callback ',
'    then',
'        g_in_error_handling_callback := true;',
'',
'        begin',
'            select /*+ result_cache */',
'                   coalesce(p.error_handling_function, f.error_handling_function)',
'              into l_error_handling_function',
'              from apex_applications f,',
'                   apex_application_pages p',
'             where f.application_id     = apex_application.g_flow_id',
'               and p.application_id (+) = f.application_id',
'               and p.page_id        (+) = apex_application.g_flow_step_id;',
'        exception when no_data_found then',
'            null;',
'        end;',
'    end if;',
'',
'    if l_error_handling_function is not null',
'    then',
'        l_statement := ''declare''||c_cr||',
'                           ''l_error apex_error.t_error;''||c_cr||',
'                       ''begin''||c_cr||',
'                           ''l_error := apex_error.g_error;''||c_cr||',
'                           ''apex_error.g_error_result := ''||l_error_handling_function||'' (''||c_cr||',
'                               ''p_error => l_error );''||c_cr||',
'                       ''end;'';',
'',
'        apex_error.g_error := p_error;',
'',
'        begin',
'            apex_exec.execute_plsql(l_statement);',
'        exception when others then',
'            apex_debug.error(''error in error handler: %s'', sqlerrm);',
'            apex_debug.error(''backtrace: %s'', dbms_utility.format_error_backtrace);',
'        end;',
'',
'        l_result := apex_error.g_error_result;',
'',
'        if l_result.message is null',
'        then',
'            l_result.message          := nvl(l_result.message,          p_error.message);',
'            l_result.additional_info  := nvl(l_result.additional_info,  p_error.additional_info);',
'            l_result.display_location := nvl(l_result.display_location, p_error.display_location);',
'            l_result.page_item_name   := nvl(l_result.page_item_name,   p_error.page_item_name);',
'            l_result.column_alias     := nvl(l_result.column_alias,     p_error.column_alias);',
'        end if;',
'    else',
'        l_result.message          := p_error.message;',
'        l_result.additional_info  := p_error.additional_info;',
'        l_result.display_location := p_error.display_location;',
'        l_result.page_item_name   := p_error.page_item_name;',
'        l_result.column_alias     := p_error.column_alias;',
'    end if;',
'',
'    if l_result.message = l_result.additional_info',
'    then',
'        l_result.additional_info := null;',
'    end if;',
'',
'    g_in_error_handling_callback := false;',
'',
'    return l_result;',
'',
'exception',
'    when others then',
'        l_result.message             := ''custom apex error handling function failed !!'';',
'        l_result.additional_info     := null;',
'        l_result.display_location    := apex_error.c_on_error_page;',
'        l_result.page_item_name      := null;',
'        l_result.column_alias        := null;',
'        g_in_error_handling_callback := false;',
'        ',
'        return l_result;',
'end error_function_callback;',
'',
'--------------------------------------------------------------------------------',
'-- checks if a given item name exists in the application as page or app item',
'--------------------------------------------------------------------------------',
'function item_exists',
'    ( p_item_name      in varchar2',
'    ) return boolean',
'is',
'    l_exists        boolean := false;',
'begin',
'',
'    for c in',
'    ( select distinct null',
'      from   (  select /*+ result_cache */',
'                       null',
'                from   apex_application_items',
'                where  application_id   = wwv_flow.g_flow_id',
'                and    item_name        = p_item_name',
'              )',
'    ) loop',
'        l_exists := true;',
'        exit;',
'    end loop;',
'',
'  return l_exists;',
'',
'end item_exists;',
'',
'------------------------------------------------------------------------------',
'-- We need to use application items within our source query for filtering',
'-- as we execute the SQL with apex_plugin_util, which has no means',
'-- of passing in values however it repalces binds of existing',
'-- application/page items',
'------------------------------------------------------------------------------',
'procedure application_item_check',
'    ( p_item_names apex_t_varchar2',
'    )',
'as',
'    l_exists            varchar2(10);',
'begin',
'',
'    for i in 1.. p_item_names.count',
'    loop',
'        if p_item_names(i) is not null',
'        then',
'',
'            if not item_exists(p_item_names(i))',
'            then',
'                --',
'                -- Application item does not exist so lets create it',
'                --',
'                --apex_debug.trace(''Creating a new application item: %s for the FOEX Scheduler Plug-in'',l_item_names(i));',
'',
'                wwv_flow_api.create_flow_item',
'                    ( p_flow_id          => wwv_flow.g_flow_id',
'                    , p_name             => p_item_names(i)',
'                    , p_data_type        => ''VARCHAR''',
'                    , p_is_persistent    => ''Y''',
'                    , p_protection_level => ''I''',
'                    , p_item_comment     => ''This item is used for the FOS - Tooltip Plug-in''',
'                    );',
'',
'            end if;',
'        end if;',
'    end loop;',
'',
'end application_item_check;',
'',
'-- function to check if the app is in dev-mode',
'function is_developer_session',
'return boolean',
'as',
'begin',
'    return (coalesce(apex_application.g_edit_cookie_session_id, v(''APP_BUILDER_SESSION'')) is not null);',
'end is_developer_session;',
'',
'function render ',
'  ( p_dynamic_action in apex_plugin.t_dynamic_action',
'  , p_plugin         in apex_plugin.t_plugin ',
'  )',
'return apex_plugin.t_dynamic_action_render_result',
'as',
'    l_result             apex_plugin.t_dynamic_action_render_result;',
'    l_id                 p_dynamic_action.id%type           := p_dynamic_action.id;',
'    -- ajax identifier',
'    l_ajax_id            l_result.ajax_identifier%type      := apex_plugin.get_ajax_identifier;',
'    -- init js ',
'    l_init_js_fn         varchar2(32767)                    := nvl(apex_plugin_util.replace_substitutions(p_dynamic_action.init_javascript_code), ''undefined'');',
'    ',
'    --attributes',
'    l_loading_text       p_plugin.attribute_01%type         := p_plugin.attribute_01;',
'    l_no_data_text       p_plugin.attribute_02%type         := p_plugin.attribute_02;',
'    l_src                p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_sql_src            p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    l_items_to_submit    p_dynamic_action.attribute_03%type := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_03);',
'    l_attr_to_submit     p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    l_static_src         p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'    l_attr_src           p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    l_plsql_src          p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;    ',
'    l_bg_color           p_dynamic_action.attribute_08%type := p_dynamic_action.attribute_08;',
'    l_txt_color          p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;',
'    l_animation          p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;',
'    l_duration           p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_11;',
'    l_display_on         p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;',
'    l_placement          p_dynamic_action.attribute_13%type := p_dynamic_action.attribute_13;',
'    l_options            p_dynamic_action.attribute_14%type := p_dynamic_action.attribute_14;',
'    ',
'    l_follow_cursor      boolean                            := instr(l_options, ''follow-cursor''   ) > 0;',
'    l_interactive_text   boolean                            := instr(l_options, ''interactive-text'') > 0;',
'    l_disable_arrow      boolean                            := instr(l_options, ''disable-arrow''   ) > 0;',
'    l_escape_html        boolean                            := instr(l_options, ''escape-html''     ) > 0;  ',
'    l_cache              boolean                            := instr(l_options, ''cache-result''    ) > 0;',
'    l_show_on_create     boolean                            := instr(l_options, ''show-on-create''  ) > 0;',
'    ',
'    l_items_to_submit_$  varchar2(32000);',
'    l_content            varchar2(32767);',
'    ',
'    l_theme_name         varchar2(1000)                     := ''fos-tooltip-theme-'' || l_id;   ',
'    l_app_items          apex_t_varchar2                    := apex_t_varchar2(G_C_ATTR_ID_1, G_C_ATTR_ID_2, G_C_ATTR_ID_3);',
'    l_exists             boolean                            := false;',
'    ',
'    l_rt_api_usage       varchar2(100);',
'    l_error_msg          varchar2(1000);',
'    ',
'begin',
'    ',
'    --debug',
'    if apex_application.g_debug and substr(:DEBUG,6) >= 6 ',
'    then',
'        apex_plugin_util.debug_dynamic_action',
'          ( p_plugin         => p_plugin',
'          , p_dynamic_action => p_dynamic_action',
'          );',
'    end if;',
'    ',
'    --add css file for the choosen animation ',
'    apex_css.add_file',
'       ( p_name       => l_animation',
'       , p_directory  => p_plugin.file_prefix || ''css/''',
'       );',
'    ',
'    --add style to the tooltips',
'    apex_css.add',
'        ( p_css => ''.tippy-box[data-theme~="''|| l_theme_name ||''"] { background-color:'' || l_bg_color || ''; color:'' || l_txt_color || ''; }'' ',
'                || ''.tippy-box[data-theme~="''|| l_theme_name ||''"] .tippy-arrow { color: '' || l_bg_color || ''; }''',
'        , p_key => ''tippy-box-'' || l_theme_name',
'        );',
'        ',
'    if (l_src = ''sql'' or l_src = ''plsql'') and is_developer_session',
'    then',
'        for i in 1 .. l_app_items.count',
'        loop',
'            l_exists := item_exists(l_app_items(i));',
'        end loop;',
'        ',
'        if not l_exists',
'        then',
'            select runtime_api_usage into l_rt_api_usage from apex_applications where application_id = :APP_ID;',
'',
'            if instr(l_rt_api_usage, ''T'') > 0',
'            then',
'                application_item_check',
'                    ( p_item_names => l_app_items',
'                    );',
'            else ',
'                l_error_msg := ''FOS - Tooltip: For full SQL / PL/SQL support some specific application items have to be created. Set the "Runtime API Usage" application attribute to "This application" and run the application once.'';',
'            end if;',
'       end if;',
'    end if;',
'    ',
'    if l_src = ''static''',
'    then',
'        l_content := apex_plugin_util.replace_substitutions',
'            ( p_value => l_static_src',
'            , p_escape => l_escape_html ',
'            );',
'    end if;',
'    ',
'    apex_json.initialize_clob_output;',
'    ',
'    apex_json.open_object;',
'    ',
'    apex_json.write(''ajaxId''         , l_ajax_id            );',
'    apex_json.write(''src''            , l_src                );',
'    apex_json.write(''itemsToSubmit''  , l_items_to_submit    , true);',
'    apex_json.write(''attrToSubmit''   , l_attr_to_submit     , true);',
'    apex_json.write(''staticSrc''      , l_static_src         );',
'    apex_json.write(''content''        , l_content            );',
'    apex_json.write(''attrSrc''        , l_attr_src           );',
'    apex_json.write(''escapeHTML''     , l_escape_html        );',
'    apex_json.write(''bgColor''        , l_bg_color           );',
'    apex_json.write(''txtColor''       , l_txt_color          );',
'    apex_json.write(''animation''      , l_animation          );',
'    apex_json.write(''duration''       , l_duration           );',
'    apex_json.write(''displayOn''      , l_display_on         );',
'    apex_json.write(''placement''      , l_placement          );',
'    apex_json.write(''theme''          , l_theme_name         );',
'    apex_json.write(''disableArrow''   , l_disable_arrow      );',
'    apex_json.write(''interactiveText'', l_interactive_text   );',
'    apex_json.write(''followCursor''   , l_follow_cursor      );',
'    apex_json.write(''errorMsg''       , l_error_msg          );',
'    apex_json.write(''cacheResult''    , l_cache              );',
'    apex_json.write(''loadingText''    , l_loading_text       );',
'    apex_json.write(''noDataFoundText'', l_no_data_text       );',
'    apex_json.write(''showOnCreate''   , l_show_on_create     );',
'    ',
'    apex_json.close_object;',
'    ',
'    l_result.javascript_function := ''function(){FOS.utils.tooltip.init(this, '' ||  apex_json.get_clob_output || '', '' || l_init_js_fn ||'');}'';',
'    ',
'    apex_json.free_output;',
'',
'    return l_result;',
'end render;',
'',
'function ajax',
'  ( p_dynamic_action in apex_plugin.t_dynamic_action',
'  , p_plugin         in apex_plugin.t_plugin',
'  )',
'return apex_plugin.t_dynamic_action_ajax_result',
'as',
'    l_return                 apex_plugin.t_dynamic_action_ajax_result;',
'    l_context                apex_exec.t_context;',
'    l_parameters             apex_exec.t_parameters;',
'    ',
'    -- error handling',
'    l_apex_error             apex_error.t_error;',
'    l_result                 apex_error.t_error_result;',
'    ',
'    l_fos_tooltip_attr_id_1  varchar2(1000)                     := apex_application.g_x01;',
'    l_fos_tooltip_attr_id_2  varchar2(1000)                     := apex_application.g_x02;',
'    l_fos_tooltip_attr_id_3  varchar2(1000)                     := apex_application.g_x03;',
'    ',
'    c_too_many_cols          constant number                    := -20001;',
'    c_too_many_rows          constant number                    := -20002;',
'    ',
'    l_source                 p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    l_sql_source             p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    l_plsql_source           p_dynamic_action.attribute_07%type := p_dynamic_action.attribute_07;',
'    l_html_expr              p_dynamic_action.attribute_15%type := p_dynamic_action.attribute_15;',
'    ',
'    l_col_count              number;',
'    l_col                    apex_exec.t_column;',
'    l_tooltip_result         varchar2(32767);',
'    l_message                varchar2(32767);',
'    ',
'    l_app_items              apex_t_varchar2                    := apex_t_varchar2(G_C_ATTR_ID_1, G_C_ATTR_ID_2, G_C_ATTR_ID_3);',
'    l_app_attr               apex_t_varchar2                    := apex_t_varchar2(l_fos_tooltip_attr_id_1, l_fos_tooltip_attr_id_2, l_fos_tooltip_attr_id_3);',
'    ',
'    function escape_html',
'      ( p_html                   in varchar2',
'      , p_escape_already_enabled in boolean',
'      ) return varchar2',
'    is ',
'    begin',
'        return case when p_escape_already_enabled then p_html else apex_escape.html(p_html) end;',
'    end escape_html;',
'    ',
'begin',
'',
'    --debug',
'    if apex_application.g_debug and substr(:DEBUG,6) >= 6 ',
'    then',
'        apex_plugin_util.debug_dynamic_action',
'          ( p_plugin         => p_plugin',
'          , p_dynamic_action => p_dynamic_action',
'          );',
'    end if;',
'    ',
'    if l_source = ''sql'' or l_source = ''plsql''',
'    then',
'        for i in 1 .. l_app_items.count',
'        loop',
'            if item_exists(l_app_items(i))',
'            then',
'                apex_util.set_session_state(l_app_items(i),l_app_attr(i));',
'            end if;',
'        end loop;',
'    end if;',
'    ',
'    if l_source = ''sql''',
'    then',
'        l_context := apex_exec.open_query_context',
'            ( p_location        => apex_exec.c_location_local_db',
'            , p_sql_query       => l_sql_source',
'            , p_max_rows        => 1',
'            );',
'        ',
'        l_col_count := apex_exec.get_column_count(l_context);',
'        ',
'        if l_html_expr is null and l_col_count > 1',
'        then',
'            raise_application_error(c_too_many_cols, ''Too many columns'');',
'        end if;',
'',
'        if apex_exec.get_total_row_count(l_context) > 1',
'        then',
'            raise_application_error(c_too_many_rows, ''Too many rows'');',
'        end if;',
'',
'        while apex_exec.next_row(l_context)',
'        loop',
'            if l_html_expr is not null',
'            then    ',
'                for i in 1 .. l_col_count',
'                loop',
'                    l_col := apex_exec.get_column(l_context,i);',
'                    l_html_expr := replace(l_html_expr,''#''|| l_col.name ||''#'',apex_exec.get_varchar2(l_context,i));',
'                end loop;',
'                l_tooltip_result := l_html_expr;',
'            else',
'                l_tooltip_result := apex_exec.get_varchar2(l_context,1);',
'            end if;',
'        end loop;',
'    ',
'        apex_exec.close(l_context);',
'        ',
'    elsif l_source = ''plsql''',
'    then',
'        l_tooltip_result := apex_plugin_util.get_plsql_function_result',
'            ( p_plsql_function => l_plsql_source',
'            );',
'    end if;',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', true            );',
'    apex_json.write(''src''    , l_tooltip_result);',
'    apex_json.close_object;',
'',
'    return l_return;',
'    ',
'exception',
'    when others then',
'        ',
'        l_message := coalesce(apex_application.g_x01, sqlerrm);',
'        l_message := replace(l_message, ''#SQLCODE#'', escape_html(sqlcode, true));',
'        l_message := replace(l_message, ''#SQLERRM#'', escape_html(sqlerrm, true));',
'        l_message := replace(l_message, ''#SQLERRM_TEXT#'', escape_html(substr(sqlerrm, instr(sqlerrm, '':'')+1), true));',
'',
'        apex_json.initialize_output;',
'        l_apex_error.message             := l_message;',
'        l_apex_error.ora_sqlcode         := sqlcode;',
'        l_apex_error.ora_sqlerrm         := sqlerrm;',
'        l_apex_error.error_backtrace     := dbms_utility.format_error_backtrace;',
'        ',
'        l_result := error_function_callback(l_apex_error);',
'',
'        apex_json.open_object;',
'        apex_json.write(''status'' , ''error'');',
'        apex_json.write(''success'', false);',
'        ',
'        case SQLCODE',
'            when c_too_many_rows then',
'                apex_json.write(''errMsg'', ''Too many rows returned, expected only one'');',
'            when c_too_many_cols then',
'                apex_json.write(''errMsg'', ''Too many columns selected, only one is allowed'');',
'            else',
'                apex_json.write(''errMsg'', SQLERRM);',
'        end case;',
'        ',
'        apex_json.close_object;',
'        sys.htp.p(apex_json.get_clob_output);',
'        apex_json.free_output;',
'        ',
'        return l_return;',
'end ajax;',
''))
,p_api_version=>2
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'ITEM:BUTTON:REGION:JQUERY_SELECTOR:JAVASCRIPT_EXPRESSION:REQUIRED:ONLOAD:INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>false
,p_subscribe_plugin_settings=>true
,p_help_text=>'<p>The <strong>FOS - Tooltip </strong> dynamic action plug-in offers a simple and powerful solution to extend any APEX application with fancy tooltips. Based on the popular open source <a href="https://atomiks.github.io/tippyjs/" target="_blank">Tipp'
||'y.js</a> javascript library, we have added plenty of great features and customization capability that you can take advantage of.</p><p>You can choose from different source options e.g. static, DOM attribute, SQL query, or PL/SQL, meaning your content'
||' can be static or dynamically fetched from the database with the option to cache the results for maximum efficiency.</p>'
,p_version_identifier=>'22.1.0'
,p_about_url=>'https://fos.world'
,p_plugin_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@fos-auto-return-to-page',
'@fos-auto-open-files:js/script.js'))
,p_files_version=>1051
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(229580914451880208)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Loading Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Loading...'
,p_is_translatable=>true
,p_help_text=>'<p>The text to display whilst the tooltip is loading. It is defined here for the ability to easily translate the text.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(229682799981865095)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'No Data Found Text'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'No Data Found!'
,p_is_translatable=>true
,p_help_text=>'<p>Enter the text you would like to display when not data is found from a tooltip which is fetched from the database via SQL/PLSQL. It is defined here for the ability to easily translate the text.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215009309085379321)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Source'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'static'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The source of the tooltip. Use the <i>Page Items to Submit</i> and <i>Attributes to Submit</i> attributes to pass "page item"/"DOM element attribute" values to the server.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215010047109384335)
,p_plugin_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_display_sequence=>10
,p_display_value=>'Static'
,p_return_value=>'static'
,p_help_text=>'<p>The content of the tooltip is a static text.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215010800759418414)
,p_plugin_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_display_sequence=>20
,p_display_value=>'SQL'
,p_return_value=>'sql'
,p_help_text=>'<p>The tooltip content is coming from a SQL query.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(220504136777754890)
,p_plugin_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_display_sequence=>30
,p_display_value=>'PL/SQL Function body returning VARCHAR2'
,p_return_value=>'plsql'
,p_help_text=>'<p>The tooltip content is coming from a PL/SQL Function body.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215010473795414959)
,p_plugin_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_display_sequence=>40
,p_display_value=>'Defined in Attribute'
,p_return_value=>'defined-in-attribute'
,p_help_text=>'<p>The tooltip content is defined in an attribute of the affected DOM element e.g. title="my tooltip content" or data-fos-tooltip="my tooltip content"</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215017169821607930)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'SQL Query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_sql_min_column_count=>1
,p_sql_max_column_count=>5
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'select description from some_table where id = :FOS_TOOLTIP_ATTR_ID_1',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>If <i>"HTML Expression"</i> is not provided, then the query must return <strong>one VARCHAR2 column</strong>. Otherwise it can contain up to 5 columns.<br>',
'You can reference other page or application items from within your application using bind syntax (for example :P1_MY_ITEM). Any items referenced also need to be included in Page Items to Submit.  In a similar same way, you have access to <i>"DOM Elem'
||'ent attribute"</i> values with the <i>"FOS_TOOLTIP_ATTR_ID_1"/2/3</i> bind variables. List the used attribute names of the affected element in the <i>"Attributes to Submit"</i> field.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215019570737734652)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Page Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false

,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'sql,plsql'
,p_help_text=>'<p>Enter the name of the page items used in the server-side code.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215020730572779195)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Attributes to Submit'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'sql,plsql'
,p_help_text=>'<p>Enter a comma separated list of the names of the DOM element attributes that used in the source definition. Maximum three attributes, they will be available on the server-side as <i><strong>FOS_TOOLTIP_ATTR_ID_1, FOS_TOOLTIP_ATTR_ID_2, FOS_TOOLTIP'
||'_ATTR_ID_3</strong></i>.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215021076643849414)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Static Content'
,p_attribute_type=>'HTML'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'static'
,p_help_text=>'<p>The text to display within the tooltip. If you are using substitutions don''t forget to include the correct escaping mode depending upon your content and substitution placement e.g. &amp;P1_ITEM_NAME!HTML. or &amp;P1_ITEM_NAME!ATTR. or &amp;P1_ITEM'
||'_NAME!STRIPHTML.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215060744850393682)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Source Attribute'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'defined-in-attribute'
,p_help_text=>'<p>The name of the DOM element attribute that contains the text to display, eg. title, data-fos-tooltip, ...</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(220507237806883239)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>25
,p_prompt=>'PL/SQL Function Body returning VARCHAR2'
,p_attribute_type=>'PLSQL FUNCTION BODY'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'plsql'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enter the PL/SQL code to generate the content of the tooltip.',
'You can reference other page or application items from within your application using bind syntax (for example :P1_MY_ITEM). Any items referenced also need to be included in Page Items to Submit.  In a similar same way, you have access to <i>"DOM Elem'
||'ent attribute"</i> values with the <i>"FOS_TOOLTIP_ATTR_ID_1"/2/3</i> bind variables. List the used attribute names of the affected element in the <i>"Attributes to Submit"</i> field.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215021689452939144)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Background Color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#007BFE'
,p_is_translatable=>false
,p_help_text=>'<p>The background color of the tooltip.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215021955404943424)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Text Color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#FFFFFF'
,p_is_translatable=>false
,p_help_text=>'<p>The color of the text in the tooltip.</p>'
);
end;
/
begin
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215022276361951045)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Animation'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'scale'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The type of animation the tooltip uses when being shown or hidden.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215022575782955672)
,p_plugin_attribute_id=>wwv_flow_api.id(215022276361951045)
,p_display_sequence=>10
,p_display_value=>'Shift away'
,p_return_value=>'shift-away'
,p_help_text=>'<p>Animation style.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215022937181956871)
,p_plugin_attribute_id=>wwv_flow_api.id(215022276361951045)
,p_display_sequence=>20
,p_display_value=>'Shift toward'
,p_return_value=>'shift-toward'
,p_help_text=>'<p>Animation style.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215023356780957665)
,p_plugin_attribute_id=>wwv_flow_api.id(215022276361951045)
,p_display_sequence=>30
,p_display_value=>'Scale'
,p_return_value=>'scale'
,p_help_text=>'<p>Animation style.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215023756955959415)
,p_plugin_attribute_id=>wwv_flow_api.id(215022276361951045)
,p_display_sequence=>40
,p_display_value=>'Perspective'
,p_return_value=>'perspective'
,p_help_text=>'<p>Animation style.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215024152313960184)
,p_plugin_attribute_id=>wwv_flow_api.id(215022276361951045)
,p_display_sequence=>50
,p_display_value=>'Fade'
,p_return_value=>'fade'
,p_help_text=>'<p>Animation style.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215024594398987326)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Duration'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'500'
,p_unit=>'ms'
,p_is_translatable=>false
,p_help_text=>'<p>Duration of the CSS transition animation in ms.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215024805954384868)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Display On'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'hover'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>The triggering event to display the tooltip.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215025145784386888)
,p_plugin_attribute_id=>wwv_flow_api.id(215024805954384868)
,p_display_sequence=>10
,p_display_value=>'Click'
,p_return_value=>'click'
,p_help_text=>'<p>The tooltip will be displayed after click.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215025575058389181)
,p_plugin_attribute_id=>wwv_flow_api.id(215024805954384868)
,p_display_sequence=>20
,p_display_value=>'Hover'
,p_return_value=>'hover'
,p_help_text=>'<p>The tooltip will be displayed after hover.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215336366223317081)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Placement'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'top'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>The tooltip position relative to its reference element.</p>',
'<p>Use <i>JavaScript Initialization Code</i> to override the <i>placement</i> attribute to add the suffix -start or -end to shift the tippy to the start or end of the reference element, instead of centering it. For example, "top-start" or "left-end".'
||'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215337020991328663)
,p_plugin_attribute_id=>wwv_flow_api.id(215336366223317081)
,p_display_sequence=>10
,p_display_value=>'Top'
,p_return_value=>'top'
,p_help_text=>'<p>The tooltip will be added above the element.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215337489692333368)
,p_plugin_attribute_id=>wwv_flow_api.id(215336366223317081)
,p_display_sequence=>20
,p_display_value=>'Right'
,p_return_value=>'right'
,p_help_text=>'<p>The tooltip will be added to the right of the element.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215337832863334811)
,p_plugin_attribute_id=>wwv_flow_api.id(215336366223317081)
,p_display_sequence=>30
,p_display_value=>'Bottom'
,p_return_value=>'bottom'
,p_help_text=>'<p>The tooltip will be added below the element.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215340090984355978)
,p_plugin_attribute_id=>wwv_flow_api.id(215336366223317081)
,p_display_sequence=>40
,p_display_value=>'Left'
,p_return_value=>'left'
,p_help_text=>'<p>The tooltip will be added to the left of the element.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(215848383881444655)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'cache-result,escape-html'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'<p>Additional options to adjust the plug-in even more.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(223906761098259741)
,p_plugin_attribute_id=>wwv_flow_api.id(215848383881444655)
,p_display_sequence=>5
,p_display_value=>'Cache Result'
,p_return_value=>'cache-result'
,p_help_text=>'<p>The result of the tooltip will be stored in memory in order to access it faster ( and to spare unnecessary requests) in the future. </p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215849446022451719)
,p_plugin_attribute_id=>wwv_flow_api.id(215848383881444655)
,p_display_sequence=>10
,p_display_value=>'Disable Arrow'
,p_return_value=>'disable-arrow'
,p_help_text=>'<p>Enable it, if you want to hide the arrow on the tooltip.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(220725018798960596)
,p_plugin_attribute_id=>wwv_flow_api.id(215848383881444655)
,p_display_sequence=>15
,p_display_value=>'Escape HTML'
,p_return_value=>'escape-html'
,p_help_text=>'<p>Check this option to escape any HTML in the text.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215850295913462521)
,p_plugin_attribute_id=>wwv_flow_api.id(215848383881444655)
,p_display_sequence=>17
,p_display_value=>'Follow Cursor'
,p_return_value=>'follow-cursor'
,p_help_text=>'<p>The tooltip will follow the cursor in the referenced element.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(215849821162456677)
,p_plugin_attribute_id=>wwv_flow_api.id(215848383881444655)
,p_display_sequence=>20
,p_display_value=>'Interactive Text'
,p_return_value=>'interactive-text'
,p_help_text=>'<p>Your tooltip can be interactive, allowing you to hover over and click inside it.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(230918490432909672)
,p_plugin_attribute_id=>wwv_flow_api.id(215848383881444655)
,p_display_sequence=>30
,p_display_value=>'Show on Creation'
,p_return_value=>'show-on-create'
,p_help_text=>'<p>Check this option to show the tooltip when it is created/initialized e.g. on page load</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(221080904391891501)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>25
,p_prompt=>'HTML Expression'
,p_attribute_type=>'HTML'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(215009309085379321)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'sql'
,p_help_text=>'<p>Enter HTML expressions to be shown in the tooltip. Use #COLUMN# syntax to show column values in HTML. In order to properly render the provided HTML, the <i>"Escape HTML"</i> option must be disabled.</p>'
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(215031499656754328)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
,p_depending_on_has_to_exist=>true
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'function (options) {',
'   // show the tooltip at the top on the left',
'   options.placement = ''top-start''; // top-end is the alternative',
'',
'   // show the tip initially where the cursor currently is, but don''t follow after showing it',
'   options.followCursor = ''initial'';',
'',
'   // the amount of milliseconds to delay before showing the tip',
'   options.delay = 500;',
'   return options;',
'}',
'</pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>This setting allows you to define a Javascript Initialization function that allows you to override any settings. These are the values which you can override:</p>',
'<h4>placement</h4>',
'<a href="https://atomiks.github.io/tippyjs/v6/all-props/#placement" target="_blank">Documentation Link</a>',
'<pre>',
'  // default',
'  placement = ''top'';',
'',
'  // full list:',
'  placement = ''top-start'';',
'  placement = ''top-end'';',
'',
'  placement = ''right'';',
'  placement = ''right-start'';',
'  placement = ''right-end'';',
'',
'  placement = ''bottom'';',
'  placement = ''bottom-start'';',
'  placement = ''bottom-end'';',
'',
'  placement = ''left'';',
'  placement = ''left-start'';',
'  placement = ''left-end'';',
'',
'  // choose the side with most space',
'  placement = ''auto'';',
'  placement = ''auto-start'';',
'  placement = ''auto-end'';',
'</pre>',
'<h4>followCursor</h4>',
'<a href="https://atomiks.github.io/tippyjs/v6/all-props/#followcursor" target="_blank">Documentation Link</a>',
'<pre>',
'  // default',
'  followCursor = false;',
'  // follow on both x and y axes',
'  followCursor = true;',
'  // follow on x axis',
'  followCursor = ''horizontal'';',
'  // follow on y axis',
'  followCursor = ''vertical'';',
'  // follow until it shows (taking into account `delay`)',
'  followCursor = ''initial'';',
'</pre>',
'<h4>delay</h4>',
'<a href="https://atomiks.github.io/tippyjs/v6/all-props/#delay" target="_blank">Documentation Link</a>',
'<pre>',
'  // default',
'  delay = 0;',
'  // show and hide delay are 100ms',
'  delay = 100;',
'  // show delay is 100ms, hide delay is 200ms',
'  delay = [100, 200];',
'  // show delay is 100ms, hide delay is the default',
'  delay = [100, null];',
'</pre>'))
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(231312882076235589)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_name=>'fos-tooltip-show'
,p_display_name=>'FOS - Tooltip - Show'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C2266696C65223A227363726970742E6A73222C226E616D6573223A5B2277696E646F77222C22464F53222C227574696C73222C22746F6F6C746970222C22696E6974222C226461436F6E74657874222C22636F6E666967';
wwv_flow_api.g_varchar2_table(2) := '222C22696E6974466E222C226166666563746564456C656D656E7473222C226C656E677468222C22646F63756D656E74222C22717565727953656C6563746F72222C22616374696F6E222C22676574222C226C6F6164696E6754657874222C226E6F4461';
wwv_flow_api.g_varchar2_table(3) := '7461466F756E6454657874222C2264656C6179222C226475726174696F6E222C227061727365496E74222C226172726F77222C2264697361626C654172726F77222C2274726967676572222C22646973706C61794F6E222C22616C6C6F7748544D4C222C';
wwv_flow_api.g_varchar2_table(4) := '2265736361706548544D4C222C22696E746572616374697665222C22696E74657261637469766554657874222C22617070656E64546F222C22626F6479222C22636F6E74656E74222C227265666572656E6365222C22676574436F6E74656E74222C226F';
wwv_flow_api.g_varchar2_table(5) := '6E53686F77222C22696E7374616E6365222C22737263222C22736574436F6E74656E74222C226361636865526573756C74222C2263616368656456616C7565222C226361636865222C226964222C225F69734665746368696E67222C2261747472696275';
wwv_flow_api.g_varchar2_table(6) := '746573546F5375626D6974222C2261747472546F5375626D6974222C2273706C6974222C22666F7245616368222C2261747472222C2270757368222C22676574417474726962757465222C2261706578222C22736572766572222C22706C7567696E222C';
wwv_flow_api.g_varchar2_table(7) := '22616A61784964222C22706167654974656D73222C226974656D73546F5375626D6974222C22783031222C22783032222C22783033222C22646F6E65222C2264617461222C2273756363657373222C22736574222C226D657373616765222C22636C6561';
wwv_flow_api.g_varchar2_table(8) := '724572726F7273222C2273686F774572726F7273222C2274797065222C226C6F636174696F6E222C226572724D7367222C226661696C222C226A71584852222C2274657874537461747573222C226572726F725468726F776E222C225F6572726F72222C';
wwv_flow_api.g_varchar2_table(9) := '22616C77617973222C2267657452656D6F7465436F6E74656E74222C2267657444796E616D6963436F6E74656E74222C226576656E74222C226F6E437265617465222C226F6E48696464656E222C227365744261636B546F44656661756C74222C226465';
wwv_flow_api.g_varchar2_table(10) := '627567222C22696E666F222C2246756E6374696F6E222C2263616C6C222C226572726F724D7367222C2273746F7265222C224D6170222C2265787069726564222C22657870697265734174222C2244617465222C226E6F77222C226B6579222C2276616C';
wwv_flow_api.g_varchar2_table(11) := '7565222C2274686973222C2264656C657465222C22726566222C227574696C222C226170706C7954656D706C617465222C22737461746963537263222C2264656661756C7445736361706546696C746572222C2224222C2261747472537263222C227469';
wwv_flow_api.g_varchar2_table(12) := '707079225D2C22736F7572636573223A5B227363726970742E6A73225D2C226D617070696E6773223A2241414541412C4F41414F432C4941414D442C4F41414F432C4B41414F2C434141432C4541433542412C49414149432C4D414151442C4941414943';
wwv_flow_api.g_varchar2_table(13) := '2C4F4141532C434141432C4541433142442C49414149432C4D41414D432C51414155462C49414149432C4D41414D432C534141572C434141432C45412B423143462C49414149432C4D41414D432C51414151432C4B41414F2C53414155432C4541415743';
wwv_flow_api.g_varchar2_table(14) := '2C45414151432C4741476C442C49414149432C45414177442C4741417243482C45414155472C694241416942432C4F414163432C53414153432C634141634E2C454141554F2C4F41414F4A2C6B4241416F42482C45414155472C6942414169424B2C4D41';
wwv_flow_api.g_varchar2_table(15) := '47764A502C4541414F512C59414163522C4541414F512C614141652C6141433343522C4541414F532C674241416B42542C4541414F532C694241416D422C694241436E44542C4541414F552C4D4141512C434141432C4941414B2C4741437242562C4541';
wwv_flow_api.g_varchar2_table(16) := '414F572C53414157432C534141535A2C4541414F572C534141552C4941433543582C4541414F612C4F414153622C4541414F632C6141437642642C4541414F652C5141412B422C5341417042662C4541414F67422C55414177422C614141652C51414368';
wwv_flow_api.g_varchar2_table(17) := '4568422C4541414F69422C574141616A422C4541414F6B422C57414333426C422C4541414F6D422C594141636E422C4541414F6F422C67424143784270422C4541414F6F422C6B4241435070422C4541414F71422C534141576A422C534141536B422C4D';
wwv_flow_api.g_varchar2_table(18) := '41452F4274422C4541414F75422C514141552C53414155432C4741437642432C45414157442C454143662C4541434178422C4541414F30422C4F4141532C53414153432C494167457A422C5341413242412C47414376422C4741416B422C774241416433';
wwv_flow_api.g_varchar2_table(19) := '422C4541414F34422C4B41412B432C5541416435422C4541414F34422C4941432F43442C45414153452C574141574A2C45414157452C45414153482C6742414372432C434143482C4741414978422C4541414F38422C594141612C43414370422C494141';
wwv_flow_api.g_varchar2_table(20) := '49432C45414163432C4541414D7A422C494141496F422C454141534D2C49414372432C47414149462C454147412C4F4146414A2C45414153452C57414157452C51414370424A2C454141534F2C614141632C4541472F422C454151522C5341413042502C';
wwv_flow_api.g_varchar2_table(21) := '47414374422C49414149512C45414171422C4741437A426E432C4541414F6F432C63414163432C4D41414D2C4B41414B432C53414153432C49414372434A2C4541416D424B2C4B41414B622C45414153482C5541415569422C61414161462C4741414D2C';
wwv_flow_api.g_varchar2_table(22) := '4941476C455A2C45414153452C5741415737422C4541414F512C614145646B432C4B41414B432C4F41414F432C4F41414F35432C4541414F36432C4F4141512C4341433343432C5541415739432C4541414F2B432C6341436C42432C4941414B622C4541';
wwv_flow_api.g_varchar2_table(23) := '416D422C4741437842632C4941414B642C4541416D422C4741437842652C4941414B662C4541416D422C4B4145724267422C4D41414D432C4941434C412C4541414B432C5341434C31422C45414153452C5741415775422C4541414B78422C4B41414F35';
wwv_flow_api.g_varchar2_table(24) := '422C4541414F532C694241436E4332432C4541414B78422C4B41414F35422C4541414F38422C6141436E42452C4541414D73422C4941414933422C454141534D2C474141496D422C4541414B78422C4F41476843632C4B41414B612C51414151432C6341';
wwv_flow_api.g_varchar2_table(25) := '4362642C4B41414B612C51414151452C574141572C4341437042432C4B41414D2C5141434E432C534141552C4F4143564A2C514141532C6B4241416F42482C4541414B512C55414731436A432C45414153452C5741415775422C4541414B432C51414155';
wwv_flow_api.g_varchar2_table(26) := '442C4541414B78422C4941414D77422C4541414B512C4F41414F2C4941433344432C4D41414B2C43414143432C4541414F432C45414159432C4B4143784272432C4541415373432C4F414153462C4541436C4270432C45414153452C574141572C6D4241';
wwv_flow_api.g_varchar2_table(27) := '416D426B432C494141612C4941437244472C5141414F2C4B41434E76432C454141534F2C614141632C4341414B2C47414570432C434131435169432C434141694278432C4741436A42412C454141534F2C614141632C4541437642502C4541415373432C';
wwv_flow_api.g_varchar2_table(28) := '4F4141532C49414374422C4341454A2C4341684649472C4341416B427A432C4741436C42652C4B41414B32422C4D41414D74442C51414151592C45414153482C55417242502C6D424171426F4378422C45414337442C45414341412C4541414F73452C53';
wwv_flow_api.g_varchar2_table(29) := '4141572C5341415533432C4741457842412C454141534F2C614141632C4541437642502C4541415373432C4F4141532C49414574422C4541436B422C554141646A452C4541414F34422C4D41435035422C4541414F75452C534141572C5341415535432C';
wwv_flow_api.g_varchar2_table(30) := '4941364768432C5341413042412C4741437442412C45414153452C5741415737422C4541414F512C61414533426D422C4541415373432C4F4141532C49414374422C43416848514F2C434141694237432C45414372422C4741454A652C4B41414B2B422C';
wwv_flow_api.g_varchar2_table(31) := '4D41414D432C4B41414B2C67424141694231452C4741473742432C6141416B4230452C5541456C4231452C4541414F32452C4B41414B37452C45414157432C4741497642412C4541414F36452C554143506E432C4B41414B2B422C4D41414D432C4B4141';
wwv_flow_api.g_varchar2_table(32) := '4B31452C4541414F36452C55414933422C4D41414D37432C454141512C4341435638432C4D41414F2C49414149432C49414358432C514141532C53414155432C474143662C4F41414F412C47414161412C45414159432C4B41414B432C4B41437A432C45';
wwv_flow_api.g_varchar2_table(33) := '41434135452C4941414B2C5341415536452C474143582C49414149432C4D414145412C4541414B4A2C55414145412C474141634B2C4B41414B522C4D41414D76452C4941414936452C494141512C434141432C4541436E442C49414149452C4B41414B4E';
wwv_flow_api.g_varchar2_table(34) := '2C51414151432C4741496A422C4F41414F492C45414848432C4B41414B522C4D41414D532C4F41414F482C45414931422C4541434139422C4941414B2C5341415538422C4541414B432C4541414F4A2C4741436C42412C49414344412C45414159432C4B';
wwv_flow_api.g_varchar2_table(35) := '41414B432C4D4141512C4D41453742472C4B41414B522C4D41414D78422C4941414938422C4541414B2C43414145432C5141414F4A2C6141436A432C47414B4A2C5341415378442C454141572B442C47414368422C4D41416B422C5541416478462C4541';
wwv_flow_api.g_varchar2_table(36) := '414F34422C49414341632C4B41414B2B432C4B41414B432C6341416331462C4541414F32462C554141572C4341433743432C6F424141714235462C4541414F6B422C574141612C4F4141532C5141456A432C77424141646C422C4541414F34422C494143';
wwv_flow_api.g_varchar2_table(37) := '5069452C454141454C2C4741414B6A442C4B41414B76432C4541414F38462C5341456E4239462C4541414F512C57414574422C43415A4175462C4D41414D37462C4541416B42462C454132453542227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(212521731038800561)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E464F533D77696E646F772E464F537C7C7B7D2C464F532E7574696C733D464F532E7574696C737C7C7B7D2C464F532E7574696C732E746F6F6C7469703D464F532E7574696C732E746F6F6C7469707C7C7B7D2C464F532E7574696C732E';
wwv_flow_api.g_varchar2_table(2) := '746F6F6C7469702E696E69743D66756E6374696F6E28652C742C6E297B6C657420693D303D3D652E6166666563746564456C656D656E74732E6C656E6774683F646F63756D656E742E717565727953656C6563746F7228652E616374696F6E2E61666665';
wwv_flow_api.g_varchar2_table(3) := '63746564456C656D656E7473293A652E6166666563746564456C656D656E74732E67657428293B742E6C6F6164696E67546578743D742E6C6F6164696E67546578747C7C224C6F6164696E672E2E2E222C742E6E6F44617461466F756E64546578743D74';
wwv_flow_api.g_varchar2_table(4) := '2E6E6F44617461466F756E64546578747C7C224E6F206461746120666F756E642E222C742E64656C61793D5B3330302C305D2C742E6475726174696F6E3D7061727365496E7428742E6475726174696F6E2C3130292C742E6172726F773D21742E646973';
wwv_flow_api.g_varchar2_table(5) := '61626C654172726F772C742E747269676765723D22686F766572223D3D742E646973706C61794F6E3F226D6F757365656E746572223A22636C69636B222C742E616C6C6F7748544D4C3D21742E65736361706548544D4C2C742E696E7465726163746976';
wwv_flow_api.g_varchar2_table(6) := '653D742E696E746572616374697665546578742C742E696E74657261637469766554657874262628742E617070656E64546F3D646F63756D656E742E626F6479292C742E636F6E74656E743D66756E6374696F6E2865297B6F2865297D2C742E6F6E5368';
wwv_flow_api.g_varchar2_table(7) := '6F773D66756E6374696F6E2865297B2166756E6374696F6E2865297B69662822646566696E65642D696E2D617474726962757465223D3D742E7372637C7C22737461746963223D3D742E73726329652E736574436F6E74656E74286F28652E7265666572';
wwv_flow_api.g_varchar2_table(8) := '656E636529293B656C73657B696628742E6361636865526573756C74297B6C657420743D722E67657428652E6964293B696628742972657475726E20652E736574436F6E74656E742874292C766F696428652E5F69734665746368696E673D2131297D21';
wwv_flow_api.g_varchar2_table(9) := '66756E6374696F6E2865297B6C6574206E3D5B5D3B742E61747472546F5375626D69743F2E73706C697428222C22292E666F72456163682828743D3E7B6E2E7075736828652E7265666572656E63652E676574417474726962757465287429297D29292C';
wwv_flow_api.g_varchar2_table(10) := '652E736574436F6E74656E7428742E6C6F6164696E6754657874292C617065782E7365727665722E706C7567696E28742E616A617849642C7B706167654974656D733A742E6974656D73546F5375626D69742C7830313A6E5B305D2C7830323A6E5B315D';
wwv_flow_api.g_varchar2_table(11) := '2C7830333A6E5B325D7D292E646F6E6528286E3D3E7B6E2E737563636573733F28652E736574436F6E74656E74286E2E7372637C7C742E6E6F44617461466F756E6454657874292C6E2E7372632626742E6361636865526573756C742626722E73657428';
wwv_flow_api.g_varchar2_table(12) := '652E69642C6E2E73726329293A28617065782E6D6573736167652E636C6561724572726F727328292C617065782E6D6573736167652E73686F774572726F7273287B747970653A226572726F72222C6C6F636174696F6E3A2270616765222C6D65737361';
wwv_flow_api.g_varchar2_table(13) := '67653A22546F6F6C746970204572726F723A20222B6E2E6572724D73677D29292C652E736574436F6E74656E74286E2E737563636573733F6E2E7372633A6E2E6572724D7367297D29292E6661696C282828742C6E2C69293D3E7B652E5F6572726F723D';
wwv_flow_api.g_varchar2_table(14) := '6E2C652E736574436F6E74656E74286052657175657374206661696C65642E20247B6E7D60297D29292E616C77617973282828293D3E7B652E5F69734665746368696E673D21317D29297D2865292C652E5F69734665746368696E673D21312C652E5F65';
wwv_flow_api.g_varchar2_table(15) := '72726F723D6E756C6C7D7D2865292C617065782E6576656E742E7472696767657228652E7265666572656E63652C22666F732D746F6F6C7469702D73686F77222C74297D2C742E6F6E4372656174653D66756E6374696F6E2865297B652E5F6973466574';
wwv_flow_api.g_varchar2_table(16) := '6368696E673D21312C652E5F6572726F723D6E756C6C7D2C2273746174696322213D742E737263262628742E6F6E48696464656E3D66756E6374696F6E2865297B2166756E6374696F6E2865297B652E736574436F6E74656E7428742E6C6F6164696E67';
wwv_flow_api.g_varchar2_table(17) := '54657874292C652E5F6572726F723D6E756C6C7D2865297D292C617065782E64656275672E696E666F2822464F53202D20546F6F6C746970222C74292C6E20696E7374616E63656F662046756E6374696F6E26266E2E63616C6C28652C74292C742E6572';
wwv_flow_api.g_varchar2_table(18) := '726F724D73672626617065782E64656275672E696E666F28742E6572726F724D7367293B636F6E737420723D7B73746F72653A6E6577204D61702C657870697265643A66756E6374696F6E2865297B72657475726E20652626653C446174652E6E6F7728';
wwv_flow_api.g_varchar2_table(19) := '297D2C6765743A66756E6374696F6E2865297B6C65747B76616C75653A742C6578706972657341743A6E7D3D746869732E73746F72652E6765742865297C7C7B7D3B69662821746869732E65787069726564286E292972657475726E20743B746869732E';
wwv_flow_api.g_varchar2_table(20) := '73746F72652E64656C6574652865297D2C7365743A66756E6374696F6E28652C742C6E297B6E7C7C286E3D446174652E6E6F7728292B33366535292C746869732E73746F72652E73657428652C7B76616C75653A742C6578706972657341743A6E7D297D';
wwv_flow_api.g_varchar2_table(21) := '7D3B66756E6374696F6E206F2865297B72657475726E22737461746963223D3D742E7372633F617065782E7574696C2E6170706C7954656D706C61746528742E7374617469635372632C7B64656661756C7445736361706546696C7465723A742E657363';

wwv_flow_api.g_varchar2_table(22) := '61706548544D4C3F2248544D4C223A22524157227D293A22646566696E65642D696E2D617474726962757465223D3D742E7372633F242865292E6174747228742E61747472537263293A742E6C6F6164696E67546578747D746970707928692C74297D3B';
wwv_flow_api.g_varchar2_table(23) := '0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D6170';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(212522120272800561)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'js/script.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A20676C6F62616C20617065782C24202A2F0A0A77696E646F772E464F53203D2077696E646F772E464F53207C7C207B7D3B0A464F532E7574696C73203D20464F532E7574696C73207C7C207B7D3B0A464F532E7574696C732E746F6F6C746970203D';
wwv_flow_api.g_varchar2_table(2) := '20464F532E7574696C732E746F6F6C746970207C7C207B7D3B0A0A2F2A2A0A2A0A2A2040706172616D207B6F626A6563747D20202009636F6E6669672009202020202020202020202020202020202020202009436F6E66696775726174696F6E206F626A';
wwv_flow_api.g_varchar2_table(3) := '65637420636F6E7461696E696E672074686520706C7567696E2073657474696E67730A2A2040706172616D207B737472696E677D20202009636F6E6669672E616E696D6174696F6E202020202020202020202020202020095468652076616C7565206368';
wwv_flow_api.g_varchar2_table(4) := '616E676520616E696D6174696F6E0A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E61747472546F5375626D697420202020202020202020202020436F6D6D6120736570617261746564206C697374206F66206174747269';
wwv_flow_api.g_varchar2_table(5) := '62757465206E616D6573202865672E2069642C20646174612D6E756D2C206574632E2E2920746861742075736564206F6E207468652073657276657220202020202020202020202020200A2A2040706172616D207B737472696E677D2020202020202063';
wwv_flow_api.g_varchar2_table(6) := '6F6E6669672E6267436F6C6F72202020202020202020202020202020202020546865206261636B67726F756E6420636F6C6F72206F662074686520746F6F6C746970202020200A2A2040706172616D207B737472696E677D20202020202020636F6E6669';
wwv_flow_api.g_varchar2_table(7) := '672E747874436F6C6F722020202020202020202020202020202020546865207465787420636F6C6F72206F662074686520746F6F6C746970202020200A2A2040706172616D207B626F6F6C65616E7D202020202020636F6E6669672E6361636865526573';
wwv_flow_api.g_varchar2_table(8) := '756C742020202020202020202020202020576865746865722073746F72652074686520726573756C7420696E206D656D6F7279206F72206E6F740A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E636F6E74656E74202020';
wwv_flow_api.g_varchar2_table(9) := '20202020202020202020202020202054686520636F6E74656E74206F662074686520746F6F6C7469700A2A2040706172616D207B626F6F6C65616E7D202020202020636F6E6669672E64697361626C654172726F77202020202020202020202020204164';
wwv_flow_api.g_varchar2_table(10) := '64206172726F777320746F2074686520746F6F6C746970206F72206E6F740A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E646973706C61794F6E202020202020202020202020202020205468652074726967676572696E';
wwv_flow_api.g_varchar2_table(11) := '67206576656E74200A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E747261696C436F6C6F72202020202020202020202020202020436F6C6F72206F66207468652070726F677265737320747261696C2E0A2A2040706172';
wwv_flow_api.g_varchar2_table(12) := '616D207B737472696E677D20202020202020636F6E6669672E6475726174696F6E20202020202020202020202020202020204475726174696F6E206F662074686520616E696D6174696F6E20696E206D730A2A2040706172616D207B626F6F6C65616E7D';
wwv_flow_api.g_varchar2_table(13) := '202020202020636F6E6669672E65736361706548544D4C20202020202020202020202020202052656E6465722048544D4C20696E2074686520746F6F6C746970206F72206E6F740A2A2040706172616D207B626F6F6C65616E7D202020202020636F6E66';
wwv_flow_api.g_varchar2_table(14) := '69672E666F6C6C6F77437572736F722020202020202020202020202054686520746F6F6C74697020666F6C6C6F77732074686520637572736F72206D6F76656D656E740A2A2040706172616D207B6E756D6265727D20202020202020636F6E6669672E68';
wwv_flow_api.g_varchar2_table(15) := '69646544656C617920202020202020202020202020202020486964652061667465722078206D730A2A2040706172616D207B626F6F6C65616E7D202020202020636F6E6669672E696E7465726163746976655465787420202020202020202020416C6C6F';
wwv_flow_api.g_varchar2_table(16) := '777320696E746572616374696F6E7320776974682074686520746F6F6C746970200A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E6C6F6164696E6754657874202020202020202020202020202054686520746578742074';
wwv_flow_api.g_varchar2_table(17) := '6F20626520646973706C61796564207768696C652077616974696E6720666F722074686520726573706F6E73650A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E6E6F44617461466F756E64546578742020202020202020';
wwv_flow_api.g_varchar2_table(18) := '2020546865207465787420746F20626520646973706C617965642069662074686520726573706F6E736520646F6573206E6F7420636F6E7461696E20616E7920646174610A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E';
wwv_flow_api.g_varchar2_table(19) := '706C6163656D656E742020202020202020202020202020202054686520706C6163656D656E74206F662074686520746F6F6C7469700A2A2040706172616D207B6E756D6265727D20202020202020636F6E6669672E73686F7744656C6179202020202020';
wwv_flow_api.g_varchar2_table(20) := '2020202020202020202053686F772061667465722078206D730A2A2040706172616D207B6E756D6265727D20202020202020636F6E6669672E73686F774F6E4372656174652020202020202020202020202053686F772074686520746F6F6C7469702069';
wwv_flow_api.g_varchar2_table(21) := '6D6D6564696174656C79207768656E2074686520706C7567696E20686173206265656E20657865637574656420652E672E206F6E2070616765206C6F61640A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E6974656D7354';
wwv_flow_api.g_varchar2_table(22) := '6F5375626D69742020202020202020202020204974656D73207573656420696E2074686520736F757263652071756572792E0A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E7468656D6520202020202020202020202020';
wwv_flow_api.g_varchar2_table(23) := '20202020202020546865206E616D65206F662074686520746F6F6C7469702773207468656D650A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E737263202020202020202020202020202020202020202020205468652074';
wwv_flow_api.g_varchar2_table(24) := '797065206F662074686520736F75726365205B7374617469637C64796E616D69635D0A2A2040706172616D207B737472696E677D20202020202020636F6E6669672E73746174696353726320202020202020202020202020202020546865207374617469';
wwv_flow_api.g_varchar2_table(25) := '63207465787420636F6E74656E74206F662074686520746F6F6C7469700A2A2040706172616D207B66756E6374696F6E7D202009696E69744A7320200909090909094F7074696F6E616C20496E697469616C697A6174696F6E204A617661536372697074';
wwv_flow_api.g_varchar2_table(26) := '20436F64652066756E6374696F6E0A2A2F0A0A464F532E7574696C732E746F6F6C7469702E696E6974203D2066756E6374696F6E20286461436F6E746578742C20636F6E6669672C20696E6974466E29207B0A20202020636F6E7374204556545F544F4F';
wwv_flow_api.g_varchar2_table(27) := '4C5449505F53484F57203D2027666F732D746F6F6C7469702D73686F77273B0A202020202F2F206765742074686520616666656374656420656C656D656E74730A202020206C6574206166666563746564456C656D656E7473203D206461436F6E746578';
wwv_flow_api.g_varchar2_table(28) := '742E6166666563746564456C656D656E74732E6C656E677468203D3D2030203F20646F63756D656E742E717565727953656C6563746F72286461436F6E746578742E616374696F6E2E6166666563746564456C656D656E747329203A206461436F6E7465';
wwv_flow_api.g_varchar2_table(29) := '78742E6166666563746564456C656D656E74732E67657428293B0A0A202020202F2F2064656661756C742076616C7565730A20202020636F6E6669672E6C6F6164696E6754657874203D20636F6E6669672E6C6F6164696E6754657874207C7C20274C6F';
wwv_flow_api.g_varchar2_table(30) := '6164696E672E2E2E273B0A20202020636F6E6669672E6E6F44617461466F756E6454657874203D20636F6E6669672E6E6F44617461466F756E6454657874207C7C20274E6F206461746120666F756E642E273B0A20202020636F6E6669672E64656C6179';
wwv_flow_api.g_varchar2_table(31) := '203D205B3330302C20305D3B0A20202020636F6E6669672E6475726174696F6E203D207061727365496E7428636F6E6669672E6475726174696F6E2C203130293B0A20202020636F6E6669672E6172726F77203D2021636F6E6669672E64697361626C65';
wwv_flow_api.g_varchar2_table(32) := '4172726F773B0A20202020636F6E6669672E74726967676572203D2028636F6E6669672E646973706C61794F6E203D3D2027686F7665722729203F20276D6F757365656E74657227203A2027636C69636B273B0A20202020636F6E6669672E616C6C6F77';
wwv_flow_api.g_varchar2_table(33) := '48544D4C203D2021636F6E6669672E65736361706548544D4C3B0A20202020636F6E6669672E696E746572616374697665203D20636F6E6669672E696E746572616374697665546578743B0A2020202069662028636F6E6669672E696E74657261637469';
wwv_flow_api.g_varchar2_table(34) := '76655465787429207B0A2020202020202020636F6E6669672E617070656E64546F203D20646F63756D656E742E626F64793B0A202020207D0A20202020636F6E6669672E636F6E74656E74203D2066756E6374696F6E20287265666572656E636529207B';
wwv_flow_api.g_varchar2_table(35) := '0A2020202020202020676574436F6E74656E74287265666572656E6365293B0A202020207D0A20202020636F6E6669672E6F6E53686F77203D2066756E6374696F6E28696E7374616E636529207B0A202020202020202067657444796E616D6963436F6E';
wwv_flow_api.g_varchar2_table(36) := '74656E7428696E7374616E6365293B0A2020202020202020617065782E6576656E742E7472696767657228696E7374616E63652E7265666572656E63652C204556545F544F4F4C5449505F53484F572C20636F6E666967293B0A202020207D0A20202020';
wwv_flow_api.g_varchar2_table(37) := '636F6E6669672E6F6E437265617465203D2066756E6374696F6E2028696E7374616E636529207B0A20202020202020202F2F205365747570206F7572206F776E20637573746F6D2073746174652070726F706572746965730A2020202020202020696E73';
wwv_flow_api.g_varchar2_table(38) := '74616E63652E5F69734665746368696E67203D2066616C73653B0A2020202020202020696E7374616E63652E5F6572726F72203D206E756C6C3B0A0A202020207D0A2020202069662028636F6E6669672E73726320213D20277374617469632729207B0A';
wwv_flow_api.g_varchar2_table(39) := '2020202020202020636F6E6669672E6F6E48696464656E203D2066756E6374696F6E2028696E7374616E636529207B0A2020202020202020202020207365744261636B546F44656661756C7428696E7374616E6365293B0A20202020202020207D0A2020';
wwv_flow_api.g_varchar2_table(40) := '20207D0A20202020617065782E64656275672E696E666F2827464F53202D20546F6F6C746970272C20636F6E666967293B0A0A202020202F2F20416C6C6F772074686520646576656C6F70657220746F20706572666F726D20616E79206C617374202863';
wwv_flow_api.g_varchar2_table(41) := '656E7472616C697A656429206368616E676573207573696E67204A61766173637269707420496E697469616C697A6174696F6E20436F64652073657474696E670A2020202069662028696E6974466E20696E7374616E63656F662046756E6374696F6E29';
wwv_flow_api.g_varchar2_table(42) := '207B0A202020202020202064656275676765723B0A2020202020202020696E6974466E2E63616C6C286461436F6E746578742C20636F6E666967293B0A202020207D0A0A202020202F2F2053686F77207761726E696E6720696620746865206E65636573';
wwv_flow_api.g_varchar2_table(43) := '73617279204170706C69636174696F6E204974656D7320617265206E6F7420617661696C61626C65200A2020202069662028636F6E6669672E6572726F724D736729207B0A2020202020202020617065782E64656275672E696E666F28636F6E6669672E';
wwv_flow_api.g_varchar2_table(44) := '6572726F724D7367293B0A202020207D0A0A202020202F2F2063616368650A20202020636F6E7374206361636865203D207B0A202020202020202073746F72653A206E6577204D617028292C0A2020202020202020657870697265643A2066756E637469';
wwv_flow_api.g_varchar2_table(45) := '6F6E202865787069726573417429207B0A20202020202020202020202072657475726E2065787069726573417420262620657870697265734174203C20446174652E6E6F7728293B0A20202020202020207D2C0A20202020202020206765743A2066756E';
wwv_flow_api.g_varchar2_table(46) := '6374696F6E20286B657929207B0A2020202020202020202020206C6574207B2076616C75652C20657870697265734174207D203D20746869732E73746F72652E676574286B657929207C7C207B7D3B0A2020202020202020202020206966202874686973';
wwv_flow_api.g_varchar2_table(47) := '2E65787069726564286578706972657341742929207B0A20202020202020202020202020202020746869732E73746F72652E64656C657465286B6579293B0A2020202020202020202020202020202072657475726E20756E646566696E65643B0A202020';
wwv_flow_api.g_varchar2_table(48) := '2020202020202020207D0A20202020202020202020202072657475726E2076616C75653B0A20202020202020207D2C0A20202020202020207365743A2066756E6374696F6E20286B65792C2076616C75652C2065787069726573417429207B0A20202020';
wwv_flow_api.g_varchar2_table(49) := '2020202020202020696620282165787069726573417429207B0A20202020202020202020202020202020657870697265734174203D20446174652E6E6F772829202B2031303030202A203630202A2036303B0A2020202020202020202020207D0A202020';
wwv_flow_api.g_varchar2_table(50) := '202020202020202020746869732E73746F72652E736574286B65792C207B2076616C75652C20657870697265734174207D293B0A20202020202020207D0A202020207D0A202020202F2F20696E697469616C697A652074686520746F6F6C7469700A2020';
wwv_flow_api.g_varchar2_table(51) := '20207469707079286166666563746564456C656D656E74732C20636F6E666967293B0A0A2020202066756E6374696F6E20676574436F6E74656E742872656629207B0A202020202020202069662028636F6E6669672E737263203D3D2027737461746963';
wwv_flow_api.g_varchar2_table(52) := '2729207B0A20202020202020202020202072657475726E20617065782E7574696C2E6170706C7954656D706C61746528636F6E6669672E7374617469635372632C207B0A2020202020202020202020202020202064656661756C7445736361706546696C';
wwv_flow_api.g_varchar2_table(53) := '7465723A20636F6E6669672E65736361706548544D4C203F202748544D4C27203A2027524157270A2020202020202020202020207D293B0A20202020202020207D20656C73652069662028636F6E6669672E737263203D3D2027646566696E65642D696E';
wwv_flow_api.g_varchar2_table(54) := '2D6174747269627574652729207B0A20202020202020202020202072657475726E202428726566292E6174747228636F6E6669672E61747472537263293B0A20202020202020207D20656C7365207B0A20202020202020202020202072657475726E2063';
wwv_flow_api.g_varchar2_table(55) := '6F6E6669672E6C6F6164696E67546578743B0A20202020202020207D0A202020207D0A0A2020202066756E6374696F6E2067657444796E616D6963436F6E74656E7428696E7374616E636529207B0A202020202020202069662028636F6E6669672E7372';
wwv_flow_api.g_varchar2_table(56) := '63203D3D2027646566696E65642D696E2D61747472696275746527207C7C20636F6E6669672E737263203D3D20277374617469632729207B0A202020202020202020202020696E7374616E63652E736574436F6E74656E7428676574436F6E74656E7428';
wwv_flow_api.g_varchar2_table(57) := '696E7374616E63652E7265666572656E636529293B0A20202020202020207D20656C7365207B0A20202020202020202020202069662028636F6E6669672E6361636865526573756C7429207B0A202020202020202020202020202020206C657420636163';
wwv_flow_api.g_varchar2_table(58) := '68656456616C7565203D2063616368652E67657428696E7374616E63652E6964293B0A202020202020202020202020202020206966202863616368656456616C756529207B0A2020202020202020202020202020202020202020696E7374616E63652E73';
wwv_flow_api.g_varchar2_table(59) := '6574436F6E74656E742863616368656456616C7565293B0A2020202020202020202020202020202020202020696E7374616E63652E5F69734665746368696E67203D2066616C73653B0A202020202020202020202020202020202020202072657475726E';
wwv_flow_api.g_varchar2_table(60) := '3B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020202020202067657452656D6F7465436F6E74656E7428696E7374616E6365293B0A202020202020202020202020696E7374616E63652E5F69734665';
wwv_flow_api.g_varchar2_table(61) := '746368696E67203D2066616C73653B0A202020202020202020202020696E7374616E63652E5F6572726F72203D206E756C6C3B0A20202020202020207D0A202020202020202072657475726E20747275653B0A202020207D0A0A2020202066756E637469';
wwv_flow_api.g_varchar2_table(62) := '6F6E2067657452656D6F7465436F6E74656E7428696E7374616E636529207B0A20202020202020206C65742061747472696275746573546F5375626D6974203D205B5D3B0A2020202020202020636F6E6669672E61747472546F5375626D69743F2E7370';
wwv_flow_api.g_varchar2_table(63) := '6C697428272C27292E666F724561636828286174747229203D3E207B0A20202020202020202020202061747472696275746573546F5375626D69742E7075736828696E7374616E63652E7265666572656E63652E67657441747472696275746528617474';
wwv_flow_api.g_varchar2_table(64) := '7229293B0A20202020202020207D293B0A0A2020202020202020696E7374616E63652E736574436F6E74656E7428636F6E6669672E6C6F6164696E6754657874293B0A20202020202020200A20202020202020206C657420726573756C74203D20617065';
wwv_flow_api.g_varchar2_table(65) := '782E7365727665722E706C7567696E28636F6E6669672E616A617849642C207B0A202020202020202020202020706167654974656D733A20636F6E6669672E6974656D73546F5375626D69742C0A2020202020202020202020207830313A206174747269';
wwv_flow_api.g_varchar2_table(66) := '6275746573546F5375626D69745B305D2C0A2020202020202020202020207830323A2061747472696275746573546F5375626D69745B315D2C0A2020202020202020202020207830333A2061747472696275746573546F5375626D69745B325D0A202020';
wwv_flow_api.g_varchar2_table(67) := '20202020207D293B0A2020202020202020726573756C742E646F6E6528286461746129203D3E207B0A20202020202020202020202069662028646174612E7375636365737329207B0A20202020202020202020202020202020696E7374616E63652E7365';
wwv_flow_api.g_varchar2_table(68) := '74436F6E74656E7428646174612E737263207C7C20636F6E6669672E6E6F44617461466F756E6454657874293B0A2020202020202020202020202020202069662028646174612E73726320262620636F6E6669672E6361636865526573756C7429207B0A';
wwv_flow_api.g_varchar2_table(69) := '202020202020202020202020202020202020202063616368652E73657428696E7374616E63652E69642C20646174612E737263293B0A202020202020202020202020202020207D0A2020202020202020202020207D20656C7365207B0A20202020202020';
wwv_flow_api.g_varchar2_table(70) := '202020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0A20202020202020202020202020202020617065782E6D6573736167652E73686F774572726F7273287B0A202020202020202020202020202020202020202074';
wwv_flow_api.g_varchar2_table(71) := '7970653A20276572726F72272C0A20202020202020202020202020202020202020206C6F636174696F6E3A202770616765272C0A20202020202020202020202020202020202020206D6573736167653A2027546F6F6C746970204572726F723A2027202B';
wwv_flow_api.g_varchar2_table(72) := '20646174612E6572724D73670A202020202020202020202020202020207D293B0A2020202020202020202020207D0A202020202020202020202020696E7374616E63652E736574436F6E74656E7428646174612E73756363657373203F20646174612E73';
wwv_flow_api.g_varchar2_table(73) := '7263203A20646174612E6572724D7367293B0A20202020202020207D292E6661696C28286A715848522C20746578745374617475732C206572726F725468726F776E29203D3E207B0A202020202020202020202020696E7374616E63652E5F6572726F72';
wwv_flow_api.g_varchar2_table(74) := '203D20746578745374617475733B0A202020202020202020202020696E7374616E63652E736574436F6E74656E74286052657175657374206661696C65642E20247B746578745374617475737D60293B0A20202020202020207D292E616C776179732828';
wwv_flow_api.g_varchar2_table(75) := '29203D3E207B0A202020202020202020202020696E7374616E63652E5F69734665746368696E67203D2066616C73653B0A20202020202020207D290A202020207D0A0A2020202066756E6374696F6E207365744261636B546F44656661756C7428696E73';
wwv_flow_api.g_varchar2_table(76) := '74616E636529207B0A2020202020202020696E7374616E63652E736574436F6E74656E7428636F6E6669672E6C6F6164696E6754657874293B0A20202020202020202F2F20556E7365742074686573652070726F7065727469657320736F206E6577206E';
wwv_flow_api.g_varchar2_table(77) := '6574776F726B2072657175657374732063616E20626520696E697469617465640A2020202020202020696E7374616E63652E5F6572726F72203D206E756C6C3B0A202020207D3B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(212524569813800564)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A307D5B646174612D74697070792D726F6F745D7B6D61782D77696474683A63616C6328313030767720';
wwv_flow_api.g_varchar2_table(2) := '2D2031307078297D2E74697070792D626F787B706F736974696F6E3A72656C61746976653B6261636B67726F756E642D636F6C6F723A233333333B636F6C6F723A236666663B626F726465722D7261646975733A3470783B666F6E742D73697A653A3134';
wwv_flow_api.g_varchar2_table(3) := '70783B6C696E652D6865696768743A312E343B77686974652D73706163653A6E6F726D616C3B6F75746C696E653A303B7472616E736974696F6E2D70726F70657274793A7472616E73666F726D2C7669736962696C6974792C6F7061636974797D2E7469';
wwv_flow_api.g_varchar2_table(4) := '7070792D626F785B646174612D706C6163656D656E745E3D746F705D3E2E74697070792D6172726F777B626F74746F6D3A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D746F705D3E2E74697070792D6172726F773A6265666F';
wwv_flow_api.g_varchar2_table(5) := '72657B626F74746F6D3A2D3770783B6C6566743A303B626F726465722D77696474683A3870782038707820303B626F726465722D746F702D636F6C6F723A696E697469616C3B7472616E73666F726D2D6F726967696E3A63656E74657220746F707D2E74';
wwv_flow_api.g_varchar2_table(6) := '697070792D626F785B646174612D706C6163656D656E745E3D626F74746F6D5D3E2E74697070792D6172726F777B746F703A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D626F74746F6D5D3E2E74697070792D6172726F773A';
wwv_flow_api.g_varchar2_table(7) := '6265666F72657B746F703A2D3770783B6C6566743A303B626F726465722D77696474683A3020387078203870783B626F726465722D626F74746F6D2D636F6C6F723A696E697469616C3B7472616E73666F726D2D6F726967696E3A63656E74657220626F';
wwv_flow_api.g_varchar2_table(8) := '74746F6D7D2E74697070792D626F785B646174612D706C6163656D656E745E3D6C6566745D3E2E74697070792D6172726F777B72696768743A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D6C6566745D3E2E74697070792D61';
wwv_flow_api.g_varchar2_table(9) := '72726F773A6265666F72657B626F726465722D77696474683A387078203020387078203870783B626F726465722D6C6566742D636F6C6F723A696E697469616C3B72696768743A2D3770783B7472616E73666F726D2D6F726967696E3A63656E74657220';
wwv_flow_api.g_varchar2_table(10) := '6C6566747D2E74697070792D626F785B646174612D706C6163656D656E745E3D72696768745D3E2E74697070792D6172726F777B6C6566743A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D72696768745D3E2E74697070792D';
wwv_flow_api.g_varchar2_table(11) := '6172726F773A6265666F72657B6C6566743A2D3770783B626F726465722D77696474683A387078203870782038707820303B626F726465722D72696768742D636F6C6F723A696E697469616C3B7472616E73666F726D2D6F726967696E3A63656E746572';
wwv_flow_api.g_varchar2_table(12) := '2072696768747D2E74697070792D626F785B646174612D696E65727469615D5B646174612D73746174653D76697369626C655D7B7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E35342C312E352C';
wwv_flow_api.g_varchar2_table(13) := '2E33382C312E3131297D2E74697070792D6172726F777B77696474683A313670783B6865696768743A313670783B636F6C6F723A233333337D2E74697070792D6172726F773A6265666F72657B636F6E74656E743A22223B706F736974696F6E3A616273';
wwv_flow_api.g_varchar2_table(14) := '6F6C7574653B626F726465722D636F6C6F723A7472616E73706172656E743B626F726465722D7374796C653A736F6C69647D2E74697070792D636F6E74656E747B706F736974696F6E3A72656C61746976653B70616464696E673A357078203970783B7A';
wwv_flow_api.g_varchar2_table(15) := '2D696E6465783A317D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(212706279417021506)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'libraries/tippy/css/tippy.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28742C65297B226F626A656374223D3D747970656F66206578706F727473262622756E646566696E656422213D747970656F66206D6F64756C653F6D6F64756C652E6578706F7274733D652872657175697265282240706F707065';
wwv_flow_api.g_varchar2_table(2) := '726A732F636F72652229293A2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B2240706F707065726A732F636F7265225D2C65293A28743D747C7C73656C66292E74697070793D652874';
wwv_flow_api.g_varchar2_table(3) := '2E506F70706572297D28746869732C2866756E6374696F6E2874297B2275736520737472696374223B76617220653D22756E646566696E656422213D747970656F662077696E646F77262622756E646566696E656422213D747970656F6620646F63756D';
wwv_flow_api.g_varchar2_table(4) := '656E742C6E3D2121652626212177696E646F772E6D7343727970746F2C723D7B706173736976653A21302C636170747572653A21307D2C6F3D66756E6374696F6E28297B72657475726E20646F63756D656E742E626F64797D3B66756E6374696F6E2069';
wwv_flow_api.g_varchar2_table(5) := '28742C652C6E297B69662841727261792E69734172726179287429297B76617220723D745B655D3B72657475726E206E756C6C3D3D723F41727261792E69734172726179286E293F6E5B655D3A6E3A727D72657475726E20747D66756E6374696F6E2061';
wwv_flow_api.g_varchar2_table(6) := '28742C65297B766172206E3D7B7D2E746F537472696E672E63616C6C2874293B72657475726E20303D3D3D6E2E696E6465784F6628225B6F626A656374222926266E2E696E6465784F6628652B225D22293E2D317D66756E6374696F6E207328742C6529';
wwv_flow_api.g_varchar2_table(7) := '7B72657475726E2266756E6374696F6E223D3D747970656F6620743F742E6170706C7928766F696420302C65293A747D66756E6374696F6E207528742C65297B72657475726E20303D3D3D653F743A66756E6374696F6E2872297B636C65617254696D65';
wwv_flow_api.g_varchar2_table(8) := '6F7574286E292C6E3D73657454696D656F7574282866756E6374696F6E28297B742872297D292C65297D3B766172206E7D66756E6374696F6E207028742C65297B766172206E3D4F626A6563742E61737369676E287B7D2C74293B72657475726E20652E';
wwv_flow_api.g_varchar2_table(9) := '666F7245616368282866756E6374696F6E2874297B64656C657465206E5B745D7D29292C6E7D66756E6374696F6E20632874297B72657475726E5B5D2E636F6E6361742874297D66756E6374696F6E206628742C65297B2D313D3D3D742E696E6465784F';
wwv_flow_api.g_varchar2_table(10) := '662865292626742E707573682865297D66756E6374696F6E206C2874297B72657475726E20742E73706C697428222D22295B305D7D66756E6374696F6E20642874297B72657475726E5B5D2E736C6963652E63616C6C2874297D66756E6374696F6E2076';
wwv_flow_api.g_varchar2_table(11) := '2874297B72657475726E204F626A6563742E6B6579732874292E726564756365282866756E6374696F6E28652C6E297B72657475726E20766F69642030213D3D745B6E5D262628655B6E5D3D745B6E5D292C657D292C7B7D297D66756E6374696F6E206D';
wwv_flow_api.g_varchar2_table(12) := '28297B72657475726E20646F63756D656E742E637265617465456C656D656E74282264697622297D66756E6374696F6E20672874297B72657475726E5B22456C656D656E74222C22467261676D656E74225D2E736F6D65282866756E6374696F6E286529';
wwv_flow_api.g_varchar2_table(13) := '7B72657475726E206128742C65297D29297D66756E6374696F6E20682874297B72657475726E206128742C224D6F7573654576656E7422297D66756E6374696F6E20622874297B72657475726E212821747C7C21742E5F74697070797C7C742E5F746970';
wwv_flow_api.g_varchar2_table(14) := '70792E7265666572656E6365213D3D74297D66756E6374696F6E20792874297B72657475726E20672874293F5B745D3A66756E6374696F6E2874297B72657475726E206128742C224E6F64654C69737422297D2874293F642874293A41727261792E6973';
wwv_flow_api.g_varchar2_table(15) := '41727261792874293F743A6428646F63756D656E742E717565727953656C6563746F72416C6C287429297D66756E6374696F6E207728742C65297B742E666F7245616368282866756E6374696F6E2874297B74262628742E7374796C652E7472616E7369';
wwv_flow_api.g_varchar2_table(16) := '74696F6E4475726174696F6E3D652B226D7322297D29297D66756E6374696F6E207828742C65297B742E666F7245616368282866756E6374696F6E2874297B742626742E7365744174747269627574652822646174612D7374617465222C65297D29297D';
wwv_flow_api.g_varchar2_table(17) := '66756E6374696F6E20452874297B76617220652C6E3D632874295B305D3B72657475726E286E756C6C3D3D6E7C7C6E756C6C3D3D28653D6E2E6F776E6572446F63756D656E74293F766F696420303A652E626F6479293F6E2E6F776E6572446F63756D65';
wwv_flow_api.g_varchar2_table(18) := '6E743A646F63756D656E747D66756E6374696F6E204F28742C652C6E297B76617220723D652B224576656E744C697374656E6572223B5B227472616E736974696F6E656E64222C227765626B69745472616E736974696F6E456E64225D2E666F72456163';
wwv_flow_api.g_varchar2_table(19) := '68282866756E6374696F6E2865297B745B725D28652C6E297D29297D66756E6374696F6E204328742C65297B666F7228766172206E3D653B6E3B297B76617220723B696628742E636F6E7461696E73286E292972657475726E21303B6E3D6E756C6C3D3D';
wwv_flow_api.g_varchar2_table(20) := '28723D6E756C6C3D3D6E2E676574526F6F744E6F64653F766F696420303A6E2E676574526F6F744E6F64652829293F766F696420303A722E686F73747D72657475726E21317D76617220543D7B6973546F7563683A21317D2C413D303B66756E6374696F';
wwv_flow_api.g_varchar2_table(21) := '6E204C28297B542E6973546F7563687C7C28542E6973546F7563683D21302C77696E646F772E706572666F726D616E63652626646F63756D656E742E6164644576656E744C697374656E657228226D6F7573656D6F7665222C4429297D66756E6374696F';
wwv_flow_api.g_varchar2_table(22) := '6E204428297B76617220743D706572666F726D616E63652E6E6F7728293B742D413C3230262628542E6973546F7563683D21312C646F63756D656E742E72656D6F76654576656E744C697374656E657228226D6F7573656D6F7665222C4429292C413D74';
wwv_flow_api.g_varchar2_table(23) := '7D66756E6374696F6E206B28297B76617220743D646F63756D656E742E616374697665456C656D656E743B69662862287429297B76617220653D742E5F74697070793B742E626C7572262621652E73746174652E697356697369626C652626742E626C75';
wwv_flow_api.g_varchar2_table(24) := '7228297D7D76617220523D4F626A6563742E61737369676E287B617070656E64546F3A6F2C617269613A7B636F6E74656E743A226175746F222C657870616E6465643A226175746F227D2C64656C61793A302C6475726174696F6E3A5B3330302C323530';
wwv_flow_api.g_varchar2_table(25) := '5D2C6765745265666572656E6365436C69656E74526563743A6E756C6C2C686964654F6E436C69636B3A21302C69676E6F7265417474726962757465733A21312C696E7465726163746976653A21312C696E746572616374697665426F726465723A322C';
wwv_flow_api.g_varchar2_table(26) := '696E7465726163746976654465626F756E63653A302C6D6F76655472616E736974696F6E3A22222C6F66667365743A5B302C31305D2C6F6E41667465725570646174653A66756E6374696F6E28297B7D2C6F6E4265666F72655570646174653A66756E63';
wwv_flow_api.g_varchar2_table(27) := '74696F6E28297B7D2C6F6E4372656174653A66756E6374696F6E28297B7D2C6F6E44657374726F793A66756E6374696F6E28297B7D2C6F6E48696464656E3A66756E6374696F6E28297B7D2C6F6E486964653A66756E6374696F6E28297B7D2C6F6E4D6F';

wwv_flow_api.g_varchar2_table(28) := '756E743A66756E6374696F6E28297B7D2C6F6E53686F773A66756E6374696F6E28297B7D2C6F6E53686F776E3A66756E6374696F6E28297B7D2C6F6E547269676765723A66756E6374696F6E28297B7D2C6F6E556E747269676765723A66756E6374696F';
wwv_flow_api.g_varchar2_table(29) := '6E28297B7D2C6F6E436C69636B4F7574736964653A66756E6374696F6E28297B7D2C706C6163656D656E743A22746F70222C706C7567696E733A5B5D2C706F707065724F7074696F6E733A7B7D2C72656E6465723A6E756C6C2C73686F774F6E43726561';
wwv_flow_api.g_varchar2_table(30) := '74653A21312C746F7563683A21302C747269676765723A226D6F757365656E74657220666F637573222C747269676765725461726765743A6E756C6C7D2C7B616E696D61746546696C6C3A21312C666F6C6C6F77437572736F723A21312C696E6C696E65';
wwv_flow_api.g_varchar2_table(31) := '506F736974696F6E696E673A21312C737469636B793A21317D2C7B7D2C7B616C6C6F7748544D4C3A21312C616E696D6174696F6E3A2266616465222C6172726F773A21302C636F6E74656E743A22222C696E65727469613A21312C6D617857696474683A';
wwv_flow_api.g_varchar2_table(32) := '3335302C726F6C653A22746F6F6C746970222C7468656D653A22222C7A496E6465783A393939397D292C503D4F626A6563742E6B6579732852293B66756E6374696F6E206A2874297B76617220653D28742E706C7567696E737C7C5B5D292E7265647563';
wwv_flow_api.g_varchar2_table(33) := '65282866756E6374696F6E28652C6E297B76617220722C6F3D6E2E6E616D652C693D6E2E64656661756C7456616C75653B6F262628655B6F5D3D766F69642030213D3D745B6F5D3F745B6F5D3A6E756C6C213D28723D525B6F5D293F723A69293B726574';
wwv_flow_api.g_varchar2_table(34) := '75726E20657D292C7B7D293B72657475726E204F626A6563742E61737369676E287B7D2C742C7B7D2C65297D66756E6374696F6E204D28742C65297B766172206E3D4F626A6563742E61737369676E287B7D2C652C7B636F6E74656E743A7328652E636F';
wwv_flow_api.g_varchar2_table(35) := '6E74656E742C5B745D297D2C652E69676E6F7265417474726962757465733F7B7D3A66756E6374696F6E28742C65297B72657475726E28653F4F626A6563742E6B657973286A284F626A6563742E61737369676E287B7D2C522C7B706C7567696E733A65';
wwv_flow_api.g_varchar2_table(36) := '7D2929293A50292E726564756365282866756E6374696F6E28652C6E297B76617220723D28742E6765744174747269627574652822646174612D74697070792D222B6E297C7C2222292E7472696D28293B69662821722972657475726E20653B69662822';
wwv_flow_api.g_varchar2_table(37) := '636F6E74656E74223D3D3D6E29655B6E5D3D723B656C7365207472797B655B6E5D3D4A534F4E2E70617273652872297D63617463682874297B655B6E5D3D727D72657475726E20657D292C7B7D297D28742C652E706C7567696E7329293B72657475726E';
wwv_flow_api.g_varchar2_table(38) := '206E2E617269613D4F626A6563742E61737369676E287B7D2C522E617269612C7B7D2C6E2E61726961292C6E2E617269613D7B657870616E6465643A226175746F223D3D3D6E2E617269612E657870616E6465643F652E696E7465726163746976653A6E';
wwv_flow_api.g_varchar2_table(39) := '2E617269612E657870616E6465642C636F6E74656E743A226175746F223D3D3D6E2E617269612E636F6E74656E743F652E696E7465726163746976653F6E756C6C3A226465736372696265646279223A6E2E617269612E636F6E74656E747D2C6E7D6675';
wwv_flow_api.g_varchar2_table(40) := '6E6374696F6E205628742C65297B742E696E6E657248544D4C3D657D66756E6374696F6E20492874297B76617220653D6D28293B72657475726E21303D3D3D743F652E636C6173734E616D653D2274697070792D6172726F77223A28652E636C6173734E';
wwv_flow_api.g_varchar2_table(41) := '616D653D2274697070792D7376672D6172726F77222C672874293F652E617070656E644368696C642874293A5628652C7429292C657D66756E6374696F6E205328742C65297B6728652E636F6E74656E74293F285628742C2222292C742E617070656E64';
wwv_flow_api.g_varchar2_table(42) := '4368696C6428652E636F6E74656E7429293A2266756E6374696F6E22213D747970656F6620652E636F6E74656E74262628652E616C6C6F7748544D4C3F5628742C652E636F6E74656E74293A742E74657874436F6E74656E743D652E636F6E74656E7429';
wwv_flow_api.g_varchar2_table(43) := '7D66756E6374696F6E20422874297B76617220653D742E6669727374456C656D656E744368696C642C6E3D6428652E6368696C6472656E293B72657475726E7B626F783A652C636F6E74656E743A6E2E66696E64282866756E6374696F6E2874297B7265';
wwv_flow_api.g_varchar2_table(44) := '7475726E20742E636C6173734C6973742E636F6E7461696E73282274697070792D636F6E74656E7422297D29292C6172726F773A6E2E66696E64282866756E6374696F6E2874297B72657475726E20742E636C6173734C6973742E636F6E7461696E7328';
wwv_flow_api.g_varchar2_table(45) := '2274697070792D6172726F7722297C7C742E636C6173734C6973742E636F6E7461696E73282274697070792D7376672D6172726F7722297D29292C6261636B64726F703A6E2E66696E64282866756E6374696F6E2874297B72657475726E20742E636C61';
wwv_flow_api.g_varchar2_table(46) := '73734C6973742E636F6E7461696E73282274697070792D6261636B64726F7022297D29297D7D66756E6374696F6E204E2874297B76617220653D6D28292C6E3D6D28293B6E2E636C6173734E616D653D2274697070792D626F78222C6E2E736574417474';
wwv_flow_api.g_varchar2_table(47) := '7269627574652822646174612D7374617465222C2268696464656E22292C6E2E7365744174747269627574652822746162696E646578222C222D3122293B76617220723D6D28293B66756E6374696F6E206F286E2C72297B766172206F3D422865292C69';
wwv_flow_api.g_varchar2_table(48) := '3D6F2E626F782C613D6F2E636F6E74656E742C733D6F2E6172726F773B722E7468656D653F692E7365744174747269627574652822646174612D7468656D65222C722E7468656D65293A692E72656D6F76654174747269627574652822646174612D7468';
wwv_flow_api.g_varchar2_table(49) := '656D6522292C22737472696E67223D3D747970656F6620722E616E696D6174696F6E3F692E7365744174747269627574652822646174612D616E696D6174696F6E222C722E616E696D6174696F6E293A692E72656D6F7665417474726962757465282264';
wwv_flow_api.g_varchar2_table(50) := '6174612D616E696D6174696F6E22292C722E696E65727469613F692E7365744174747269627574652822646174612D696E6572746961222C2222293A692E72656D6F76654174747269627574652822646174612D696E657274696122292C692E7374796C';
wwv_flow_api.g_varchar2_table(51) := '652E6D617857696474683D226E756D626572223D3D747970656F6620722E6D617857696474683F722E6D617857696474682B227078223A722E6D617857696474682C722E726F6C653F692E7365744174747269627574652822726F6C65222C722E726F6C';
wwv_flow_api.g_varchar2_table(52) := '65293A692E72656D6F76654174747269627574652822726F6C6522292C6E2E636F6E74656E743D3D3D722E636F6E74656E7426266E2E616C6C6F7748544D4C3D3D3D722E616C6C6F7748544D4C7C7C5328612C742E70726F7073292C722E6172726F773F';
wwv_flow_api.g_varchar2_table(53) := '733F6E2E6172726F77213D3D722E6172726F77262628692E72656D6F76654368696C642873292C692E617070656E644368696C64284928722E6172726F772929293A692E617070656E644368696C64284928722E6172726F7729293A732626692E72656D';
wwv_flow_api.g_varchar2_table(54) := '6F76654368696C642873297D72657475726E20722E636C6173734E616D653D2274697070792D636F6E74656E74222C722E7365744174747269627574652822646174612D7374617465222C2268696464656E22292C5328722C742E70726F7073292C652E';
wwv_flow_api.g_varchar2_table(55) := '617070656E644368696C64286E292C6E2E617070656E644368696C642872292C6F28742E70726F70732C742E70726F7073292C7B706F707065723A652C6F6E5570646174653A6F7D7D4E2E242474697070793D21303B76617220483D312C553D5B5D2C5F';
wwv_flow_api.g_varchar2_table(56) := '3D5B5D3B66756E6374696F6E207A28652C61297B76617220702C672C622C792C412C4C2C442C6B2C503D4D28652C4F626A6563742E61737369676E287B7D2C522C7B7D2C6A28762861292929292C563D21312C493D21312C533D21312C4E3D21312C7A3D';
wwv_flow_api.g_varchar2_table(57) := '5B5D2C463D752877742C502E696E7465726163746976654465626F756E6365292C573D482B2B2C583D286B3D502E706C7567696E73292E66696C746572282866756E6374696F6E28742C65297B72657475726E206B2E696E6465784F662874293D3D3D65';
wwv_flow_api.g_varchar2_table(58) := '7D29292C593D7B69643A572C7265666572656E63653A652C706F707065723A6D28292C706F70706572496E7374616E63653A6E756C6C2C70726F70733A502C73746174653A7B6973456E61626C65643A21302C697356697369626C653A21312C69734465';
wwv_flow_api.g_varchar2_table(59) := '7374726F7965643A21312C69734D6F756E7465643A21312C697353686F776E3A21317D2C706C7567696E733A582C636C65617244656C617954696D656F7574733A66756E6374696F6E28297B636C65617254696D656F75742870292C636C65617254696D';
wwv_flow_api.g_varchar2_table(60) := '656F75742867292C63616E63656C416E696D6174696F6E4672616D652862297D2C73657450726F70733A66756E6374696F6E2874297B696628592E73746174652E697344657374726F7965642972657475726E3B617428226F6E4265666F726555706461';
wwv_flow_api.g_varchar2_table(61) := '7465222C5B592C745D292C627428293B766172206E3D592E70726F70732C723D4D28652C4F626A6563742E61737369676E287B7D2C6E2C7B7D2C762874292C7B69676E6F7265417474726962757465733A21307D29293B592E70726F70733D722C687428';
wwv_flow_api.g_varchar2_table(62) := '292C6E2E696E7465726163746976654465626F756E6365213D3D722E696E7465726163746976654465626F756E6365262628707428292C463D752877742C722E696E7465726163746976654465626F756E636529293B6E2E747269676765725461726765';
wwv_flow_api.g_varchar2_table(63) := '74262621722E747269676765725461726765743F63286E2E74726967676572546172676574292E666F7245616368282866756E6374696F6E2874297B742E72656D6F76654174747269627574652822617269612D657870616E64656422297D29293A722E';
wwv_flow_api.g_varchar2_table(64) := '747269676765725461726765742626652E72656D6F76654174747269627574652822617269612D657870616E64656422293B757428292C697428292C4A26264A286E2C72293B592E706F70706572496E7374616E6365262628437428292C417428292E66';
wwv_flow_api.g_varchar2_table(65) := '6F7245616368282866756E6374696F6E2874297B72657175657374416E696D6174696F6E4672616D6528742E5F74697070792E706F70706572496E7374616E63652E666F726365557064617465297D2929293B617428226F6E4166746572557064617465';
wwv_flow_api.g_varchar2_table(66) := '222C5B592C745D297D2C736574436F6E74656E743A66756E6374696F6E2874297B592E73657450726F7073287B636F6E74656E743A747D297D2C73686F773A66756E6374696F6E28297B76617220743D592E73746174652E697356697369626C652C653D';
wwv_flow_api.g_varchar2_table(67) := '592E73746174652E697344657374726F7965642C6E3D21592E73746174652E6973456E61626C65642C723D542E6973546F756368262621592E70726F70732E746F7563682C613D6928592E70726F70732E6475726174696F6E2C302C522E647572617469';
wwv_flow_api.g_varchar2_table(68) := '6F6E293B696628747C7C657C7C6E7C7C722972657475726E3B696628657428292E686173417474726962757465282264697361626C656422292972657475726E3B696628617428226F6E53686F77222C5B595D2C2131292C21313D3D3D592E70726F7073';
wwv_flow_api.g_varchar2_table(69) := '2E6F6E53686F772859292972657475726E3B592E73746174652E697356697369626C653D21302C74742829262628242E7374796C652E7669736962696C6974793D2276697369626C6522293B697428292C647428292C592E73746174652E69734D6F756E';
wwv_flow_api.g_varchar2_table(70) := '7465647C7C28242E7374796C652E7472616E736974696F6E3D226E6F6E6522293B69662874742829297B76617220753D727428292C703D752E626F782C633D752E636F6E74656E743B77285B702C635D2C30297D4C3D66756E6374696F6E28297B766172';
wwv_flow_api.g_varchar2_table(71) := '20743B696628592E73746174652E697356697369626C652626214E297B6966284E3D21302C242E6F66667365744865696768742C242E7374796C652E7472616E736974696F6E3D592E70726F70732E6D6F76655472616E736974696F6E2C747428292626';
wwv_flow_api.g_varchar2_table(72) := '592E70726F70732E616E696D6174696F6E297B76617220653D727428292C6E3D652E626F782C723D652E636F6E74656E743B77285B6E2C725D2C61292C78285B6E2C725D2C2276697369626C6522297D737428292C757428292C66285F2C59292C6E756C';
wwv_flow_api.g_varchar2_table(73) := '6C3D3D28743D592E706F70706572496E7374616E6365297C7C742E666F72636555706461746528292C617428226F6E4D6F756E74222C5B595D292C592E70726F70732E616E696D6174696F6E262674742829262666756E6374696F6E28742C65297B6D74';
wwv_flow_api.g_varchar2_table(74) := '28742C65297D28612C2866756E6374696F6E28297B592E73746174652E697353686F776E3D21302C617428226F6E53686F776E222C5B595D297D29297D7D2C66756E6374696F6E28297B76617220742C653D592E70726F70732E617070656E64546F2C6E';
wwv_flow_api.g_varchar2_table(75) := '3D657428293B743D592E70726F70732E696E7465726163746976652626653D3D3D6F7C7C22706172656E74223D3D3D653F6E2E706172656E744E6F64653A7328652C5B6E5D293B742E636F6E7461696E732824297C7C742E617070656E644368696C6428';
wwv_flow_api.g_varchar2_table(76) := '24293B592E73746174652E69734D6F756E7465643D21302C437428297D28297D2C686964653A66756E6374696F6E28297B76617220743D21592E73746174652E697356697369626C652C653D592E73746174652E697344657374726F7965642C6E3D2159';
wwv_flow_api.g_varchar2_table(77) := '2E73746174652E6973456E61626C65642C723D6928592E70726F70732E6475726174696F6E2C312C522E6475726174696F6E293B696628747C7C657C7C6E2972657475726E3B696628617428226F6E48696465222C5B595D2C2131292C21313D3D3D592E';
wwv_flow_api.g_varchar2_table(78) := '70726F70732E6F6E486964652859292972657475726E3B592E73746174652E697356697369626C653D21312C592E73746174652E697353686F776E3D21312C4E3D21312C563D21312C74742829262628242E7374796C652E7669736962696C6974793D22';
wwv_flow_api.g_varchar2_table(79) := '68696464656E22293B696628707428292C767428292C6974282130292C74742829297B766172206F3D727428292C613D6F2E626F782C733D6F2E636F6E74656E743B592E70726F70732E616E696D6174696F6E26262877285B612C735D2C72292C78285B';
wwv_flow_api.g_varchar2_table(80) := '612C735D2C2268696464656E2229297D737428292C757428292C592E70726F70732E616E696D6174696F6E3F74742829262666756E6374696F6E28742C65297B6D7428742C2866756E6374696F6E28297B21592E73746174652E697356697369626C6526';
wwv_flow_api.g_varchar2_table(81) := '26242E706172656E744E6F64652626242E706172656E744E6F64652E636F6E7461696E7328242926266528297D29297D28722C592E756E6D6F756E74293A592E756E6D6F756E7428297D2C6869646557697468496E74657261637469766974793A66756E';
wwv_flow_api.g_varchar2_table(82) := '6374696F6E2874297B6E7428292E6164644576656E744C697374656E657228226D6F7573656D6F7665222C46292C6628552C46292C462874297D2C656E61626C653A66756E6374696F6E28297B592E73746174652E6973456E61626C65643D21307D2C64';
wwv_flow_api.g_varchar2_table(83) := '697361626C653A66756E6374696F6E28297B592E6869646528292C592E73746174652E6973456E61626C65643D21317D2C756E6D6F756E743A66756E6374696F6E28297B592E73746174652E697356697369626C652626592E6869646528293B69662821';
wwv_flow_api.g_varchar2_table(84) := '592E73746174652E69734D6F756E7465642972657475726E3B547428292C417428292E666F7245616368282866756E6374696F6E2874297B742E5F74697070792E756E6D6F756E7428297D29292C242E706172656E744E6F64652626242E706172656E74';
wwv_flow_api.g_varchar2_table(85) := '4E6F64652E72656D6F76654368696C642824293B5F3D5F2E66696C746572282866756E6374696F6E2874297B72657475726E2074213D3D597D29292C592E73746174652E69734D6F756E7465643D21312C617428226F6E48696464656E222C5B595D297D';
wwv_flow_api.g_varchar2_table(86) := '2C64657374726F793A66756E6374696F6E28297B696628592E73746174652E697344657374726F7965642972657475726E3B592E636C65617244656C617954696D656F75747328292C592E756E6D6F756E7428292C627428292C64656C65746520652E5F';
wwv_flow_api.g_varchar2_table(87) := '74697070792C592E73746174652E697344657374726F7965643D21302C617428226F6E44657374726F79222C5B595D297D7D3B69662821502E72656E6465722972657475726E20593B76617220713D502E72656E6465722859292C243D712E706F707065';
wwv_flow_api.g_varchar2_table(88) := '722C4A3D712E6F6E5570646174653B242E7365744174747269627574652822646174612D74697070792D726F6F74222C2222292C242E69643D2274697070792D222B592E69642C592E706F707065723D242C652E5F74697070793D592C242E5F74697070';
wwv_flow_api.g_varchar2_table(89) := '793D593B76617220473D582E6D6170282866756E6374696F6E2874297B72657475726E20742E666E2859297D29292C4B3D652E6861734174747269627574652822617269612D657870616E64656422293B72657475726E20687428292C757428292C6974';
wwv_flow_api.g_varchar2_table(90) := '28292C617428226F6E437265617465222C5B595D292C502E73686F774F6E43726561746526264C7428292C242E6164644576656E744C697374656E657228226D6F757365656E746572222C2866756E6374696F6E28297B592E70726F70732E696E746572';
wwv_flow_api.g_varchar2_table(91) := '6163746976652626592E73746174652E697356697369626C652626592E636C65617244656C617954696D656F75747328297D29292C242E6164644576656E744C697374656E657228226D6F7573656C65617665222C2866756E6374696F6E28297B592E70';
wwv_flow_api.g_varchar2_table(92) := '726F70732E696E7465726163746976652626592E70726F70732E747269676765722E696E6465784F6628226D6F757365656E74657222293E3D3026266E7428292E6164644576656E744C697374656E657228226D6F7573656D6F7665222C46297D29292C';
wwv_flow_api.g_varchar2_table(93) := '593B66756E6374696F6E205128297B76617220743D592E70726F70732E746F7563683B72657475726E2041727261792E697341727261792874293F743A5B742C305D7D66756E6374696F6E205A28297B72657475726E22686F6C64223D3D3D5128295B30';
wwv_flow_api.g_varchar2_table(94) := '5D7D66756E6374696F6E20747428297B76617220743B72657475726E2121286E756C6C3D3D28743D592E70726F70732E72656E646572293F766F696420303A742E24247469707079297D66756E6374696F6E20657428297B72657475726E20447C7C657D';
wwv_flow_api.g_varchar2_table(95) := '66756E6374696F6E206E7428297B76617220743D657428292E706172656E744E6F64653B72657475726E20743F452874293A646F63756D656E747D66756E6374696F6E20727428297B72657475726E20422824297D66756E6374696F6E206F742874297B';
wwv_flow_api.g_varchar2_table(96) := '72657475726E20592E73746174652E69734D6F756E746564262621592E73746174652E697356697369626C657C7C542E6973546F7563687C7C79262622666F637573223D3D3D792E747970653F303A6928592E70726F70732E64656C61792C743F303A31';
wwv_flow_api.g_varchar2_table(97) := '2C522E64656C6179297D66756E6374696F6E2069742874297B766F696420303D3D3D74262628743D2131292C242E7374796C652E706F696E7465724576656E74733D592E70726F70732E696E746572616374697665262621743F22223A226E6F6E65222C';
wwv_flow_api.g_varchar2_table(98) := '242E7374796C652E7A496E6465783D22222B592E70726F70732E7A496E6465787D66756E6374696F6E20617428742C652C6E297B76617220723B28766F696420303D3D3D6E2626286E3D2130292C472E666F7245616368282866756E6374696F6E286E29';
wwv_flow_api.g_varchar2_table(99) := '7B6E5B745D26266E5B745D2E6170706C7928766F696420302C65297D29292C6E29262628723D592E70726F7073295B745D2E6170706C7928722C65297D66756E6374696F6E20737428297B76617220743D592E70726F70732E617269613B696628742E63';
wwv_flow_api.g_varchar2_table(100) := '6F6E74656E74297B766172206E3D22617269612D222B742E636F6E74656E742C723D242E69643B6328592E70726F70732E747269676765725461726765747C7C65292E666F7245616368282866756E6374696F6E2874297B76617220653D742E67657441';
wwv_flow_api.g_varchar2_table(101) := '7474726962757465286E293B696628592E73746174652E697356697369626C6529742E736574417474726962757465286E2C653F652B2220222B723A72293B656C73657B766172206F3D652626652E7265706C61636528722C2222292E7472696D28293B';
wwv_flow_api.g_varchar2_table(102) := '6F3F742E736574417474726962757465286E2C6F293A742E72656D6F7665417474726962757465286E297D7D29297D7D66756E6374696F6E20757428297B214B2626592E70726F70732E617269612E657870616E64656426266328592E70726F70732E74';
wwv_flow_api.g_varchar2_table(103) := '7269676765725461726765747C7C65292E666F7245616368282866756E6374696F6E2874297B592E70726F70732E696E7465726163746976653F742E7365744174747269627574652822617269612D657870616E646564222C592E73746174652E697356';
wwv_flow_api.g_varchar2_table(104) := '697369626C652626743D3D3D657428293F2274727565223A2266616C736522293A742E72656D6F76654174747269627574652822617269612D657870616E64656422297D29297D66756E6374696F6E20707428297B6E7428292E72656D6F76654576656E';
wwv_flow_api.g_varchar2_table(105) := '744C697374656E657228226D6F7573656D6F7665222C46292C553D552E66696C746572282866756E6374696F6E2874297B72657475726E2074213D3D467D29297D66756E6374696F6E2063742874297B69662821542E6973546F7563687C7C2153262622';
wwv_flow_api.g_varchar2_table(106) := '6D6F757365646F776E22213D3D742E74797065297B766172206E3D742E636F6D706F736564506174682626742E636F6D706F7365645061746828295B305D7C7C742E7461726765743B69662821592E70726F70732E696E7465726163746976657C7C2143';
wwv_flow_api.g_varchar2_table(107) := '28242C6E29297B6966286328592E70726F70732E747269676765725461726765747C7C65292E736F6D65282866756E6374696F6E2874297B72657475726E204328742C6E297D2929297B696628542E6973546F7563682972657475726E3B696628592E73';
wwv_flow_api.g_varchar2_table(108) := '746174652E697356697369626C652626592E70726F70732E747269676765722E696E6465784F662822636C69636B22293E3D302972657475726E7D656C736520617428226F6E436C69636B4F757473696465222C5B592C745D293B21303D3D3D592E7072';
wwv_flow_api.g_varchar2_table(109) := '6F70732E686964654F6E436C69636B262628592E636C65617244656C617954696D656F75747328292C592E6869646528292C493D21302C73657454696D656F7574282866756E6374696F6E28297B493D21317D29292C592E73746174652E69734D6F756E';
wwv_flow_api.g_varchar2_table(110) := '7465647C7C76742829297D7D7D66756E6374696F6E20667428297B533D21307D66756E6374696F6E206C7428297B533D21317D66756E6374696F6E20647428297B76617220743D6E7428293B742E6164644576656E744C697374656E657228226D6F7573';
wwv_flow_api.g_varchar2_table(111) := '65646F776E222C63742C2130292C742E6164644576656E744C697374656E65722822746F756368656E64222C63742C72292C742E6164644576656E744C697374656E65722822746F7563687374617274222C6C742C72292C742E6164644576656E744C69';
wwv_flow_api.g_varchar2_table(112) := '7374656E65722822746F7563686D6F7665222C66742C72297D66756E6374696F6E20767428297B76617220743D6E7428293B742E72656D6F76654576656E744C697374656E657228226D6F757365646F776E222C63742C2130292C742E72656D6F766545';
wwv_flow_api.g_varchar2_table(113) := '76656E744C697374656E65722822746F756368656E64222C63742C72292C742E72656D6F76654576656E744C697374656E65722822746F7563687374617274222C6C742C72292C742E72656D6F76654576656E744C697374656E65722822746F7563686D';
wwv_flow_api.g_varchar2_table(114) := '6F7665222C66742C72297D66756E6374696F6E206D7428742C65297B766172206E3D727428292E626F783B66756E6374696F6E20722874297B742E7461726765743D3D3D6E2626284F286E2C2272656D6F7665222C72292C652829297D696628303D3D3D';
wwv_flow_api.g_varchar2_table(115) := '742972657475726E206528293B4F286E2C2272656D6F7665222C41292C4F286E2C22616464222C72292C413D727D66756E6374696F6E20677428742C6E2C72297B766F696420303D3D3D72262628723D2131292C6328592E70726F70732E747269676765';
wwv_flow_api.g_varchar2_table(116) := '725461726765747C7C65292E666F7245616368282866756E6374696F6E2865297B652E6164644576656E744C697374656E657228742C6E2C72292C7A2E70757368287B6E6F64653A652C6576656E74547970653A742C68616E646C65723A6E2C6F707469';
wwv_flow_api.g_varchar2_table(117) := '6F6E733A727D297D29297D66756E6374696F6E20687428297B76617220743B5A282926262867742822746F7563687374617274222C79742C7B706173736976653A21307D292C67742822746F756368656E64222C78742C7B706173736976653A21307D29';
wwv_flow_api.g_varchar2_table(118) := '292C28743D592E70726F70732E747269676765722C742E73706C6974282F5C732B2F292E66696C74657228426F6F6C65616E29292E666F7245616368282866756E6374696F6E2874297B696628226D616E75616C22213D3D742973776974636828677428';
wwv_flow_api.g_varchar2_table(119) := '742C7974292C74297B63617365226D6F757365656E746572223A677428226D6F7573656C65617665222C7874293B627265616B3B6361736522666F637573223A6774286E3F22666F6375736F7574223A22626C7572222C4574293B627265616B3B636173';
wwv_flow_api.g_varchar2_table(120) := '6522666F637573696E223A67742822666F6375736F7574222C4574297D7D29297D66756E6374696F6E20627428297B7A2E666F7245616368282866756E6374696F6E2874297B76617220653D742E6E6F64652C6E3D742E6576656E74547970652C723D74';
wwv_flow_api.g_varchar2_table(121) := '2E68616E646C65722C6F3D742E6F7074696F6E733B652E72656D6F76654576656E744C697374656E6572286E2C722C6F297D29292C7A3D5B5D7D66756E6374696F6E2079742874297B76617220652C6E3D21313B696628592E73746174652E6973456E61';
wwv_flow_api.g_varchar2_table(122) := '626C65642626214F7428742926262149297B76617220723D22666F637573223D3D3D286E756C6C3D3D28653D79293F766F696420303A652E74797065293B793D742C443D742E63757272656E745461726765742C757428292C21592E73746174652E6973';
wwv_flow_api.g_varchar2_table(123) := '56697369626C652626682874292626552E666F7245616368282866756E6374696F6E2865297B72657475726E20652874297D29292C22636C69636B223D3D3D742E74797065262628592E70726F70732E747269676765722E696E6465784F6628226D6F75';
wwv_flow_api.g_varchar2_table(124) := '7365656E74657222293C307C7C562926262131213D3D592E70726F70732E686964654F6E436C69636B2626592E73746174652E697356697369626C653F6E3D21303A4C742874292C22636C69636B223D3D3D742E74797065262628563D216E292C6E2626';
wwv_flow_api.g_varchar2_table(125) := '2172262644742874297D7D66756E6374696F6E2077742874297B76617220653D742E7461726765742C6E3D657428292E636F6E7461696E732865297C7C242E636F6E7461696E732865293B226D6F7573656D6F7665223D3D3D742E7479706526266E7C7C';
wwv_flow_api.g_varchar2_table(126) := '66756E6374696F6E28742C65297B766172206E3D652E636C69656E74582C723D652E636C69656E74593B72657475726E20742E6576657279282866756E6374696F6E2874297B76617220653D742E706F70706572526563742C6F3D742E706F7070657253';
wwv_flow_api.g_varchar2_table(127) := '746174652C693D742E70726F70732E696E746572616374697665426F726465722C613D6C286F2E706C6163656D656E74292C733D6F2E6D6F64696669657273446174612E6F66667365743B69662821732972657475726E21303B76617220753D22626F74';
wwv_flow_api.g_varchar2_table(128) := '746F6D223D3D3D613F732E746F702E793A302C703D22746F70223D3D3D613F732E626F74746F6D2E793A302C633D227269676874223D3D3D613F732E6C6566742E783A302C663D226C656674223D3D3D613F732E72696768742E783A302C643D652E746F';
wwv_flow_api.g_varchar2_table(129) := '702D722B753E692C763D722D652E626F74746F6D2D703E692C6D3D652E6C6566742D6E2B633E692C673D6E2D652E72696768742D663E693B72657475726E20647C7C767C7C6D7C7C677D29297D28417428292E636F6E6361742824292E6D617028286675';
wwv_flow_api.g_varchar2_table(130) := '6E6374696F6E2874297B76617220652C6E3D6E756C6C3D3D28653D742E5F74697070792E706F70706572496E7374616E6365293F766F696420303A652E73746174653B72657475726E206E3F7B706F70706572526563743A742E676574426F756E64696E';
wwv_flow_api.g_varchar2_table(131) := '67436C69656E745265637428292C706F7070657253746174653A6E2C70726F70733A507D3A6E756C6C7D29292E66696C74657228426F6F6C65616E292C7429262628707428292C4474287429297D66756E6374696F6E2078742874297B4F742874297C7C';
wwv_flow_api.g_varchar2_table(132) := '592E70726F70732E747269676765722E696E6465784F662822636C69636B22293E3D302626567C7C28592E70726F70732E696E7465726163746976653F592E6869646557697468496E74657261637469766974792874293A4474287429297D66756E6374';
wwv_flow_api.g_varchar2_table(133) := '696F6E2045742874297B592E70726F70732E747269676765722E696E6465784F662822666F637573696E22293C302626742E746172676574213D3D657428297C7C592E70726F70732E696E7465726163746976652626742E72656C617465645461726765';
wwv_flow_api.g_varchar2_table(134) := '742626242E636F6E7461696E7328742E72656C61746564546172676574297C7C44742874297D66756E6374696F6E204F742874297B72657475726E2121542E6973546F75636826265A2829213D3D742E747970652E696E6465784F662822746F75636822';
wwv_flow_api.g_varchar2_table(135) := '293E3D307D66756E6374696F6E20437428297B547428293B766172206E3D592E70726F70732C723D6E2E706F707065724F7074696F6E732C6F3D6E2E706C6163656D656E742C693D6E2E6F66667365742C613D6E2E6765745265666572656E6365436C69';
wwv_flow_api.g_varchar2_table(136) := '656E74526563742C733D6E2E6D6F76655472616E736974696F6E2C753D747428293F422824292E6172726F773A6E756C6C2C703D613F7B676574426F756E64696E67436C69656E74526563743A612C636F6E74657874456C656D656E743A612E636F6E74';
wwv_flow_api.g_varchar2_table(137) := '657874456C656D656E747C7C657428297D3A652C633D5B7B6E616D653A226F6666736574222C6F7074696F6E733A7B6F66667365743A697D7D2C7B6E616D653A2270726576656E744F766572666C6F77222C6F7074696F6E733A7B70616464696E673A7B';
wwv_flow_api.g_varchar2_table(138) := '746F703A322C626F74746F6D3A322C6C6566743A352C72696768743A357D7D7D2C7B6E616D653A22666C6970222C6F7074696F6E733A7B70616464696E673A357D7D2C7B6E616D653A22636F6D707574655374796C6573222C6F7074696F6E733A7B6164';
wwv_flow_api.g_varchar2_table(139) := '6170746976653A21737D7D2C7B6E616D653A2224247469707079222C656E61626C65643A21302C70686173653A226265666F72655772697465222C72657175697265733A5B22636F6D707574655374796C6573225D2C666E3A66756E6374696F6E287429';
wwv_flow_api.g_varchar2_table(140) := '7B76617220653D742E73746174653B69662874742829297B766172206E3D727428292E626F783B5B22706C6163656D656E74222C227265666572656E63652D68696464656E222C2265736361706564225D2E666F7245616368282866756E6374696F6E28';
wwv_flow_api.g_varchar2_table(141) := '74297B22706C6163656D656E74223D3D3D743F6E2E7365744174747269627574652822646174612D706C6163656D656E74222C652E706C6163656D656E74293A652E617474726962757465732E706F707065725B22646174612D706F707065722D222B74';
wwv_flow_api.g_varchar2_table(142) := '5D3F6E2E7365744174747269627574652822646174612D222B742C2222293A6E2E72656D6F76654174747269627574652822646174612D222B74297D29292C652E617474726962757465732E706F707065723D7B7D7D7D7D5D3B74742829262675262663';
wwv_flow_api.g_varchar2_table(143) := '2E70757368287B6E616D653A226172726F77222C6F7074696F6E733A7B656C656D656E743A752C70616464696E673A337D7D292C632E707573682E6170706C7928632C286E756C6C3D3D723F766F696420303A722E6D6F64696669657273297C7C5B5D29';
wwv_flow_api.g_varchar2_table(144) := '2C592E706F70706572496E7374616E63653D742E637265617465506F7070657228702C242C4F626A6563742E61737369676E287B7D2C722C7B706C6163656D656E743A6F2C6F6E46697273745570646174653A4C2C6D6F646966696572733A637D29297D';
wwv_flow_api.g_varchar2_table(145) := '66756E6374696F6E20547428297B592E706F70706572496E7374616E6365262628592E706F70706572496E7374616E63652E64657374726F7928292C592E706F70706572496E7374616E63653D6E756C6C297D66756E6374696F6E20417428297B726574';
wwv_flow_api.g_varchar2_table(146) := '75726E206428242E717565727953656C6563746F72416C6C28225B646174612D74697070792D726F6F745D2229297D66756E6374696F6E204C742874297B592E636C65617244656C617954696D656F75747328292C742626617428226F6E547269676765';
wwv_flow_api.g_varchar2_table(147) := '72222C5B592C745D292C647428293B76617220653D6F74282130292C6E3D5128292C723D6E5B305D2C6F3D6E5B315D3B542E6973546F756368262622686F6C64223D3D3D7226266F262628653D6F292C653F703D73657454696D656F7574282866756E63';
wwv_flow_api.g_varchar2_table(148) := '74696F6E28297B592E73686F7728297D292C65293A592E73686F7728297D66756E6374696F6E2044742874297B696628592E636C65617244656C617954696D656F75747328292C617428226F6E556E74726967676572222C5B592C745D292C592E737461';
wwv_flow_api.g_varchar2_table(149) := '74652E697356697369626C65297B6966282128592E70726F70732E747269676765722E696E6465784F6628226D6F757365656E74657222293E3D302626592E70726F70732E747269676765722E696E6465784F662822636C69636B22293E3D3026265B22';
wwv_flow_api.g_varchar2_table(150) := '6D6F7573656C65617665222C226D6F7573656D6F7665225D2E696E6465784F6628742E74797065293E3D3026265629297B76617220653D6F74282131293B653F673D73657454696D656F7574282866756E6374696F6E28297B592E73746174652E697356';
wwv_flow_api.g_varchar2_table(151) := '697369626C652626592E6869646528297D292C65293A623D72657175657374416E696D6174696F6E4672616D65282866756E6374696F6E28297B592E6869646528297D29297D7D656C736520767428297D7D66756E6374696F6E204628742C65297B766F';

wwv_flow_api.g_varchar2_table(152) := '696420303D3D3D65262628653D7B7D293B766172206E3D522E706C7567696E732E636F6E63617428652E706C7567696E737C7C5B5D293B646F63756D656E742E6164644576656E744C697374656E65722822746F7563687374617274222C4C2C72292C77';
wwv_flow_api.g_varchar2_table(153) := '696E646F772E6164644576656E744C697374656E65722822626C7572222C6B293B766172206F3D4F626A6563742E61737369676E287B7D2C652C7B706C7567696E733A6E7D292C693D792874292E726564756365282866756E6374696F6E28742C65297B';
wwv_flow_api.g_varchar2_table(154) := '766172206E3D6526267A28652C6F293B72657475726E206E2626742E70757368286E292C747D292C5B5D293B72657475726E20672874293F695B305D3A697D462E64656661756C7450726F70733D522C462E73657444656661756C7450726F70733D6675';
wwv_flow_api.g_varchar2_table(155) := '6E6374696F6E2874297B4F626A6563742E6B6579732874292E666F7245616368282866756E6374696F6E2865297B525B655D3D745B655D7D29297D2C462E63757272656E74496E7075743D543B76617220573D4F626A6563742E61737369676E287B7D2C';
wwv_flow_api.g_varchar2_table(156) := '742E6170706C795374796C65732C7B6566666563743A66756E6374696F6E2874297B76617220653D742E73746174652C6E3D7B706F707065723A7B706F736974696F6E3A652E6F7074696F6E732E73747261746567792C6C6566743A2230222C746F703A';
wwv_flow_api.g_varchar2_table(157) := '2230222C6D617267696E3A2230227D2C6172726F773A7B706F736974696F6E3A226162736F6C757465227D2C7265666572656E63653A7B7D7D3B4F626A6563742E61737369676E28652E656C656D656E74732E706F707065722E7374796C652C6E2E706F';
wwv_flow_api.g_varchar2_table(158) := '70706572292C652E7374796C65733D6E2C652E656C656D656E74732E6172726F7726264F626A6563742E61737369676E28652E656C656D656E74732E6172726F772E7374796C652C6E2E6172726F77297D7D292C583D7B6D6F7573656F7665723A226D6F';
wwv_flow_api.g_varchar2_table(159) := '757365656E746572222C666F637573696E3A22666F637573222C636C69636B3A22636C69636B227D3B76617220593D7B6E616D653A22616E696D61746546696C6C222C64656661756C7456616C75653A21312C666E3A66756E6374696F6E2874297B7661';
wwv_flow_api.g_varchar2_table(160) := '7220653B69662821286E756C6C3D3D28653D742E70726F70732E72656E646572293F766F696420303A652E24247469707079292972657475726E7B7D3B766172206E3D4228742E706F70706572292C723D6E2E626F782C6F3D6E2E636F6E74656E742C69';
wwv_flow_api.g_varchar2_table(161) := '3D742E70726F70732E616E696D61746546696C6C3F66756E6374696F6E28297B76617220743D6D28293B72657475726E20742E636C6173734E616D653D2274697070792D6261636B64726F70222C78285B745D2C2268696464656E22292C747D28293A6E';
wwv_flow_api.g_varchar2_table(162) := '756C6C3B72657475726E7B6F6E4372656174653A66756E6374696F6E28297B69262628722E696E736572744265666F726528692C722E6669727374456C656D656E744368696C64292C722E7365744174747269627574652822646174612D616E696D6174';
wwv_flow_api.g_varchar2_table(163) := '6566696C6C222C2222292C722E7374796C652E6F766572666C6F773D2268696464656E222C742E73657450726F7073287B6172726F773A21312C616E696D6174696F6E3A2273686966742D61776179227D29297D2C6F6E4D6F756E743A66756E6374696F';
wwv_flow_api.g_varchar2_table(164) := '6E28297B69662869297B76617220743D722E7374796C652E7472616E736974696F6E4475726174696F6E2C653D4E756D62657228742E7265706C61636528226D73222C222229293B6F2E7374796C652E7472616E736974696F6E44656C61793D4D617468';
wwv_flow_api.g_varchar2_table(165) := '2E726F756E6428652F3130292B226D73222C692E7374796C652E7472616E736974696F6E4475726174696F6E3D742C78285B695D2C2276697369626C6522297D7D2C6F6E53686F773A66756E6374696F6E28297B69262628692E7374796C652E7472616E';
wwv_flow_api.g_varchar2_table(166) := '736974696F6E4475726174696F6E3D22306D7322297D2C6F6E486964653A66756E6374696F6E28297B69262678285B695D2C2268696464656E22297D7D7D7D3B76617220713D7B636C69656E74583A302C636C69656E74593A307D2C243D5B5D3B66756E';
wwv_flow_api.g_varchar2_table(167) := '6374696F6E204A2874297B76617220653D742E636C69656E74582C6E3D742E636C69656E74593B713D7B636C69656E74583A652C636C69656E74593A6E7D7D76617220473D7B6E616D653A22666F6C6C6F77437572736F72222C64656661756C7456616C';
wwv_flow_api.g_varchar2_table(168) := '75653A21312C666E3A66756E6374696F6E2874297B76617220653D742E7265666572656E63652C6E3D4528742E70726F70732E747269676765725461726765747C7C65292C723D21312C6F3D21312C693D21302C613D742E70726F70733B66756E637469';
wwv_flow_api.g_varchar2_table(169) := '6F6E207328297B72657475726E22696E697469616C223D3D3D742E70726F70732E666F6C6C6F77437572736F722626742E73746174652E697356697369626C657D66756E6374696F6E207528297B6E2E6164644576656E744C697374656E657228226D6F';
wwv_flow_api.g_varchar2_table(170) := '7573656D6F7665222C66297D66756E6374696F6E207028297B6E2E72656D6F76654576656E744C697374656E657228226D6F7573656D6F7665222C66297D66756E6374696F6E206328297B723D21302C742E73657450726F7073287B6765745265666572';
wwv_flow_api.g_varchar2_table(171) := '656E6365436C69656E74526563743A6E756C6C7D292C723D21317D66756E6374696F6E2066286E297B76617220723D216E2E7461726765747C7C652E636F6E7461696E73286E2E746172676574292C6F3D742E70726F70732E666F6C6C6F77437572736F';
wwv_flow_api.g_varchar2_table(172) := '722C693D6E2E636C69656E74582C613D6E2E636C69656E74592C733D652E676574426F756E64696E67436C69656E745265637428292C753D692D732E6C6566742C703D612D732E746F703B21722626742E70726F70732E696E7465726163746976657C7C';
wwv_flow_api.g_varchar2_table(173) := '742E73657450726F7073287B6765745265666572656E6365436C69656E74526563743A66756E6374696F6E28297B76617220743D652E676574426F756E64696E67436C69656E745265637428292C6E3D692C723D613B22696E697469616C223D3D3D6F26';
wwv_flow_api.g_varchar2_table(174) := '26286E3D742E6C6566742B752C723D742E746F702B70293B76617220733D22686F72697A6F6E74616C223D3D3D6F3F742E746F703A722C633D22766572746963616C223D3D3D6F3F742E72696768743A6E2C663D22686F72697A6F6E74616C223D3D3D6F';
wwv_flow_api.g_varchar2_table(175) := '3F742E626F74746F6D3A722C6C3D22766572746963616C223D3D3D6F3F742E6C6566743A6E3B72657475726E7B77696474683A632D6C2C6865696768743A662D732C746F703A732C72696768743A632C626F74746F6D3A662C6C6566743A6C7D7D7D297D';
wwv_flow_api.g_varchar2_table(176) := '66756E6374696F6E206C28297B742E70726F70732E666F6C6C6F77437572736F72262628242E70757368287B696E7374616E63653A742C646F633A6E7D292C66756E6374696F6E2874297B742E6164644576656E744C697374656E657228226D6F757365';
wwv_flow_api.g_varchar2_table(177) := '6D6F7665222C4A297D286E29297D66756E6374696F6E206428297B303D3D3D28243D242E66696C746572282866756E6374696F6E2865297B72657475726E20652E696E7374616E6365213D3D747D2929292E66696C746572282866756E6374696F6E2874';
wwv_flow_api.g_varchar2_table(178) := '297B72657475726E20742E646F633D3D3D6E7D29292E6C656E677468262666756E6374696F6E2874297B742E72656D6F76654576656E744C697374656E657228226D6F7573656D6F7665222C4A297D286E297D72657475726E7B6F6E4372656174653A6C';
wwv_flow_api.g_varchar2_table(179) := '2C6F6E44657374726F793A642C6F6E4265666F72655570646174653A66756E6374696F6E28297B613D742E70726F70737D2C6F6E41667465725570646174653A66756E6374696F6E28652C6E297B76617220693D6E2E666F6C6C6F77437572736F723B72';
wwv_flow_api.g_varchar2_table(180) := '7C7C766F69642030213D3D692626612E666F6C6C6F77437572736F72213D3D692626286428292C693F286C28292C21742E73746174652E69734D6F756E7465647C7C6F7C7C7328297C7C752829293A287028292C63282929297D2C6F6E4D6F756E743A66';
wwv_flow_api.g_varchar2_table(181) := '756E6374696F6E28297B742E70726F70732E666F6C6C6F77437572736F722626216F26262869262628662871292C693D2131292C7328297C7C752829297D2C6F6E547269676765723A66756E6374696F6E28742C65297B68286529262628713D7B636C69';
wwv_flow_api.g_varchar2_table(182) := '656E74583A652E636C69656E74582C636C69656E74593A652E636C69656E74597D292C6F3D22666F637573223D3D3D652E747970657D2C6F6E48696464656E3A66756E6374696F6E28297B742E70726F70732E666F6C6C6F77437572736F722626286328';
wwv_flow_api.g_varchar2_table(183) := '292C7028292C693D2130297D7D7D7D3B766172204B3D7B6E616D653A22696E6C696E65506F736974696F6E696E67222C64656661756C7456616C75653A21312C666E3A66756E6374696F6E2874297B76617220652C6E3D742E7265666572656E63653B76';
wwv_flow_api.g_varchar2_table(184) := '617220723D2D312C6F3D21312C693D5B5D2C613D7B6E616D653A227469707079496E6C696E65506F736974696F6E696E67222C656E61626C65643A21302C70686173653A2261667465725772697465222C666E3A66756E6374696F6E286F297B76617220';
wwv_flow_api.g_varchar2_table(185) := '613D6F2E73746174653B742E70726F70732E696E6C696E65506F736974696F6E696E672626282D31213D3D692E696E6465784F6628612E706C6163656D656E7429262628693D5B5D292C65213D3D612E706C6163656D656E7426262D313D3D3D692E696E';
wwv_flow_api.g_varchar2_table(186) := '6465784F6628612E706C6163656D656E7429262628692E7075736828612E706C6163656D656E74292C742E73657450726F7073287B6765745265666572656E6365436C69656E74526563743A66756E6374696F6E28297B72657475726E2066756E637469';
wwv_flow_api.g_varchar2_table(187) := '6F6E2874297B72657475726E2066756E6374696F6E28742C652C6E2C72297B6966286E2E6C656E6774683C327C7C6E756C6C3D3D3D742972657475726E20653B696628323D3D3D6E2E6C656E6774682626723E3D3026266E5B305D2E6C6566743E6E5B31';
wwv_flow_api.g_varchar2_table(188) := '5D2E72696768742972657475726E206E5B725D7C7C653B7377697463682874297B6361736522746F70223A6361736522626F74746F6D223A766172206F3D6E5B305D2C693D6E5B6E2E6C656E6774682D315D2C613D22746F70223D3D3D742C733D6F2E74';
wwv_flow_api.g_varchar2_table(189) := '6F702C753D692E626F74746F6D2C703D613F6F2E6C6566743A692E6C6566742C633D613F6F2E72696768743A692E72696768743B72657475726E7B746F703A732C626F74746F6D3A752C6C6566743A702C72696768743A632C77696474683A632D702C68';
wwv_flow_api.g_varchar2_table(190) := '65696768743A752D737D3B63617365226C656674223A63617365227269676874223A76617220663D4D6174682E6D696E2E6170706C79284D6174682C6E2E6D6170282866756E6374696F6E2874297B72657475726E20742E6C6566747D2929292C6C3D4D';
wwv_flow_api.g_varchar2_table(191) := '6174682E6D61782E6170706C79284D6174682C6E2E6D6170282866756E6374696F6E2874297B72657475726E20742E72696768747D2929292C643D6E2E66696C746572282866756E6374696F6E2865297B72657475726E226C656674223D3D3D743F652E';
wwv_flow_api.g_varchar2_table(192) := '6C6566743D3D3D663A652E72696768743D3D3D6C7D29292C763D645B305D2E746F702C6D3D645B642E6C656E6774682D315D2E626F74746F6D3B72657475726E7B746F703A762C626F74746F6D3A6D2C6C6566743A662C72696768743A6C2C7769647468';
wwv_flow_api.g_varchar2_table(193) := '3A6C2D662C6865696768743A6D2D767D3B64656661756C743A72657475726E20657D7D286C2874292C6E2E676574426F756E64696E67436C69656E745265637428292C64286E2E676574436C69656E7452656374732829292C72297D28612E706C616365';
wwv_flow_api.g_varchar2_table(194) := '6D656E74297D7D29292C653D612E706C6163656D656E74297D7D3B66756E6374696F6E207328297B76617220653B6F7C7C28653D66756E6374696F6E28742C65297B766172206E3B72657475726E7B706F707065724F7074696F6E733A4F626A6563742E';
wwv_flow_api.g_varchar2_table(195) := '61737369676E287B7D2C742E706F707065724F7074696F6E732C7B6D6F646966696572733A5B5D2E636F6E6361742828286E756C6C3D3D286E3D742E706F707065724F7074696F6E73293F766F696420303A6E2E6D6F64696669657273297C7C5B5D292E';
wwv_flow_api.g_varchar2_table(196) := '66696C746572282866756E6374696F6E2874297B72657475726E20742E6E616D65213D3D652E6E616D657D29292C5B655D297D297D7D28742E70726F70732C61292C6F3D21302C742E73657450726F70732865292C6F3D2131297D72657475726E7B6F6E';
wwv_flow_api.g_varchar2_table(197) := '4372656174653A732C6F6E41667465725570646174653A732C6F6E547269676765723A66756E6374696F6E28652C6E297B69662868286E29297B766172206F3D6428742E7265666572656E63652E676574436C69656E7452656374732829292C693D6F2E';
wwv_flow_api.g_varchar2_table(198) := '66696E64282866756E6374696F6E2874297B72657475726E20742E6C6566742D323C3D6E2E636C69656E74582626742E72696768742B323E3D6E2E636C69656E74582626742E746F702D323C3D6E2E636C69656E74592626742E626F74746F6D2B323E3D';
wwv_flow_api.g_varchar2_table(199) := '6E2E636C69656E74597D29292C613D6F2E696E6465784F662869293B723D613E2D313F613A727D7D2C6F6E48696464656E3A66756E6374696F6E28297B723D2D317D7D7D7D3B76617220513D7B6E616D653A22737469636B79222C64656661756C745661';
wwv_flow_api.g_varchar2_table(200) := '6C75653A21312C666E3A66756E6374696F6E2874297B76617220653D742E7265666572656E63652C6E3D742E706F707065723B66756E6374696F6E20722865297B72657475726E21303D3D3D742E70726F70732E737469636B797C7C742E70726F70732E';
wwv_flow_api.g_varchar2_table(201) := '737469636B793D3D3D657D766172206F3D6E756C6C2C693D6E756C6C3B66756E6374696F6E206128297B76617220733D7228227265666572656E636522293F28742E706F70706572496E7374616E63653F742E706F70706572496E7374616E63652E7374';
wwv_flow_api.g_varchar2_table(202) := '6174652E656C656D656E74732E7265666572656E63653A65292E676574426F756E64696E67436C69656E745265637428293A6E756C6C2C753D722822706F7070657222293F6E2E676574426F756E64696E67436C69656E745265637428293A6E756C6C3B';
wwv_flow_api.g_varchar2_table(203) := '287326265A286F2C73297C7C7526265A28692C7529292626742E706F70706572496E7374616E63652626742E706F70706572496E7374616E63652E75706461746528292C6F3D732C693D752C742E73746174652E69734D6F756E74656426267265717565';
wwv_flow_api.g_varchar2_table(204) := '7374416E696D6174696F6E4672616D652861297D72657475726E7B6F6E4D6F756E743A66756E6374696F6E28297B742E70726F70732E737469636B7926266128297D7D7D7D3B66756E6374696F6E205A28742C65297B72657475726E21747C7C21657C7C';
wwv_flow_api.g_varchar2_table(205) := '28742E746F70213D3D652E746F707C7C742E7269676874213D3D652E72696768747C7C742E626F74746F6D213D3D652E626F74746F6D7C7C742E6C656674213D3D652E6C656674297D72657475726E2065262666756E6374696F6E2874297B7661722065';
wwv_flow_api.g_varchar2_table(206) := '3D646F63756D656E742E637265617465456C656D656E7428227374796C6522293B652E74657874436F6E74656E743D742C652E7365744174747269627574652822646174612D74697070792D7374796C657368656574222C2222293B766172206E3D646F';
wwv_flow_api.g_varchar2_table(207) := '63756D656E742E686561642C723D646F63756D656E742E717565727953656C6563746F722822686561643E7374796C652C686561643E6C696E6B22293B723F6E2E696E736572744265666F726528652C72293A6E2E617070656E644368696C642865297D';
wwv_flow_api.g_varchar2_table(208) := '28272E74697070792D626F785B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A307D5B646174612D74697070792D726F6F745D7B6D61782D77696474683A63616C632831303076';
wwv_flow_api.g_varchar2_table(209) := '77202D2031307078297D2E74697070792D626F787B706F736974696F6E3A72656C61746976653B6261636B67726F756E642D636F6C6F723A233333333B636F6C6F723A236666663B626F726465722D7261646975733A3470783B666F6E742D73697A653A';
wwv_flow_api.g_varchar2_table(210) := '313470783B6C696E652D6865696768743A312E343B77686974652D73706163653A6E6F726D616C3B6F75746C696E653A303B7472616E736974696F6E2D70726F70657274793A7472616E73666F726D2C7669736962696C6974792C6F7061636974797D2E';
wwv_flow_api.g_varchar2_table(211) := '74697070792D626F785B646174612D706C6163656D656E745E3D746F705D3E2E74697070792D6172726F777B626F74746F6D3A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D746F705D3E2E74697070792D6172726F773A6265';
wwv_flow_api.g_varchar2_table(212) := '666F72657B626F74746F6D3A2D3770783B6C6566743A303B626F726465722D77696474683A3870782038707820303B626F726465722D746F702D636F6C6F723A696E697469616C3B7472616E73666F726D2D6F726967696E3A63656E74657220746F707D';
wwv_flow_api.g_varchar2_table(213) := '2E74697070792D626F785B646174612D706C6163656D656E745E3D626F74746F6D5D3E2E74697070792D6172726F777B746F703A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D626F74746F6D5D3E2E74697070792D6172726F';
wwv_flow_api.g_varchar2_table(214) := '773A6265666F72657B746F703A2D3770783B6C6566743A303B626F726465722D77696474683A3020387078203870783B626F726465722D626F74746F6D2D636F6C6F723A696E697469616C3B7472616E73666F726D2D6F726967696E3A63656E74657220';
wwv_flow_api.g_varchar2_table(215) := '626F74746F6D7D2E74697070792D626F785B646174612D706C6163656D656E745E3D6C6566745D3E2E74697070792D6172726F777B72696768743A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D6C6566745D3E2E7469707079';
wwv_flow_api.g_varchar2_table(216) := '2D6172726F773A6265666F72657B626F726465722D77696474683A387078203020387078203870783B626F726465722D6C6566742D636F6C6F723A696E697469616C3B72696768743A2D3770783B7472616E73666F726D2D6F726967696E3A63656E7465';
wwv_flow_api.g_varchar2_table(217) := '72206C6566747D2E74697070792D626F785B646174612D706C6163656D656E745E3D72696768745D3E2E74697070792D6172726F777B6C6566743A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D72696768745D3E2E74697070';
wwv_flow_api.g_varchar2_table(218) := '792D6172726F773A6265666F72657B6C6566743A2D3770783B626F726465722D77696474683A387078203870782038707820303B626F726465722D72696768742D636F6C6F723A696E697469616C3B7472616E73666F726D2D6F726967696E3A63656E74';
wwv_flow_api.g_varchar2_table(219) := '65722072696768747D2E74697070792D626F785B646174612D696E65727469615D5B646174612D73746174653D76697369626C655D7B7472616E736974696F6E2D74696D696E672D66756E6374696F6E3A63756269632D62657A696572282E35342C312E';
wwv_flow_api.g_varchar2_table(220) := '352C2E33382C312E3131297D2E74697070792D6172726F777B77696474683A313670783B6865696768743A313670783B636F6C6F723A233333337D2E74697070792D6172726F773A6265666F72657B636F6E74656E743A22223B706F736974696F6E3A61';
wwv_flow_api.g_varchar2_table(221) := '62736F6C7574653B626F726465722D636F6C6F723A7472616E73706172656E743B626F726465722D7374796C653A736F6C69647D2E74697070792D636F6E74656E747B706F736974696F6E3A72656C61746976653B70616464696E673A35707820397078';
wwv_flow_api.g_varchar2_table(222) := '3B7A2D696E6465783A317D27292C462E73657444656661756C7450726F7073287B706C7567696E733A5B592C472C4B2C515D2C72656E6465723A4E7D292C462E63726561746553696E676C65746F6E3D66756E6374696F6E28742C65297B766172206E3B';
wwv_flow_api.g_varchar2_table(223) := '766F696420303D3D3D65262628653D7B7D293B76617220722C6F3D742C693D5B5D2C613D5B5D2C733D652E6F76657272696465732C753D5B5D2C663D21313B66756E6374696F6E206C28297B613D6F2E6D6170282866756E6374696F6E2874297B726574';
wwv_flow_api.g_varchar2_table(224) := '75726E206328742E70726F70732E747269676765725461726765747C7C742E7265666572656E6365297D29292E726564756365282866756E6374696F6E28742C65297B72657475726E20742E636F6E6361742865297D292C5B5D297D66756E6374696F6E';
wwv_flow_api.g_varchar2_table(225) := '206428297B693D6F2E6D6170282866756E6374696F6E2874297B72657475726E20742E7265666572656E63657D29297D66756E6374696F6E20762874297B6F2E666F7245616368282866756E6374696F6E2865297B743F652E656E61626C6528293A652E';
wwv_flow_api.g_varchar2_table(226) := '64697361626C6528297D29297D66756E6374696F6E20672874297B72657475726E206F2E6D6170282866756E6374696F6E2865297B766172206E3D652E73657450726F70733B72657475726E20652E73657450726F70733D66756E6374696F6E286F297B';
wwv_flow_api.g_varchar2_table(227) := '6E286F292C652E7265666572656E63653D3D3D722626742E73657450726F7073286F297D2C66756E6374696F6E28297B652E73657450726F70733D6E7D7D29297D66756E6374696F6E206828742C65297B766172206E3D612E696E6465784F662865293B';
wwv_flow_api.g_varchar2_table(228) := '69662865213D3D72297B723D653B76617220753D28737C7C5B5D292E636F6E6361742822636F6E74656E7422292E726564756365282866756E6374696F6E28742C65297B72657475726E20745B655D3D6F5B6E5D2E70726F70735B655D2C747D292C7B7D';
wwv_flow_api.g_varchar2_table(229) := '293B742E73657450726F7073284F626A6563742E61737369676E287B7D2C752C7B6765745265666572656E6365436C69656E74526563743A2266756E6374696F6E223D3D747970656F6620752E6765745265666572656E6365436C69656E74526563743F';
wwv_flow_api.g_varchar2_table(230) := '752E6765745265666572656E6365436C69656E74526563743A66756E6374696F6E28297B76617220743B72657475726E206E756C6C3D3D28743D695B6E5D293F766F696420303A742E676574426F756E64696E67436C69656E745265637428297D7D2929';
wwv_flow_api.g_varchar2_table(231) := '7D7D76282131292C6428292C6C28293B76617220623D7B666E3A66756E6374696F6E28297B72657475726E7B6F6E44657374726F793A66756E6374696F6E28297B76282130297D2C6F6E48696464656E3A66756E6374696F6E28297B723D6E756C6C7D2C';
wwv_flow_api.g_varchar2_table(232) := '6F6E436C69636B4F7574736964653A66756E6374696F6E2874297B742E70726F70732E73686F774F6E43726561746526262166262628663D21302C723D6E756C6C297D2C6F6E53686F773A66756E6374696F6E2874297B742E70726F70732E73686F774F';
wwv_flow_api.g_varchar2_table(233) := '6E43726561746526262166262628663D21302C6828742C695B305D29297D2C6F6E547269676765723A66756E6374696F6E28742C65297B6828742C652E63757272656E74546172676574297D7D7D7D2C793D46286D28292C4F626A6563742E6173736967';
wwv_flow_api.g_varchar2_table(234) := '6E287B7D2C7028652C5B226F7665727269646573225D292C7B706C7567696E733A5B625D2E636F6E63617428652E706C7567696E737C7C5B5D292C747269676765725461726765743A612C706F707065724F7074696F6E733A4F626A6563742E61737369';
wwv_flow_api.g_varchar2_table(235) := '676E287B7D2C652E706F707065724F7074696F6E732C7B6D6F646966696572733A5B5D2E636F6E63617428286E756C6C3D3D286E3D652E706F707065724F7074696F6E73293F766F696420303A6E2E6D6F64696669657273297C7C5B5D2C5B575D297D29';
wwv_flow_api.g_varchar2_table(236) := '7D29292C773D792E73686F773B792E73686F773D66756E6374696F6E2874297B6966287728292C217226266E756C6C3D3D742972657475726E206828792C695B305D293B69662821727C7C6E756C6C213D74297B696628226E756D626572223D3D747970';
wwv_flow_api.g_varchar2_table(237) := '656F6620742972657475726E20695B745D26266828792C695B745D293B6966286F2E696E6465784F662874293E3D30297B76617220653D742E7265666572656E63653B72657475726E206828792C65297D72657475726E20692E696E6465784F66287429';
wwv_flow_api.g_varchar2_table(238) := '3E3D303F6828792C74293A766F696420307D7D2C792E73686F774E6578743D66756E6374696F6E28297B76617220743D695B305D3B69662821722972657475726E20792E73686F772830293B76617220653D692E696E6465784F662872293B792E73686F';
wwv_flow_api.g_varchar2_table(239) := '7728695B652B315D7C7C74297D2C792E73686F7750726576696F75733D66756E6374696F6E28297B76617220743D695B692E6C656E6774682D315D3B69662821722972657475726E20792E73686F772874293B76617220653D692E696E6465784F662872';
wwv_flow_api.g_varchar2_table(240) := '292C6E3D695B652D315D7C7C743B792E73686F77286E297D3B76617220783D792E73657450726F70733B72657475726E20792E73657450726F70733D66756E6374696F6E2874297B733D742E6F76657272696465737C7C732C782874297D2C792E736574';
wwv_flow_api.g_varchar2_table(241) := '496E7374616E6365733D66756E6374696F6E2874297B76282130292C752E666F7245616368282866756E6374696F6E2874297B72657475726E207428297D29292C6F3D742C76282131292C6428292C6C28292C753D672879292C792E73657450726F7073';
wwv_flow_api.g_varchar2_table(242) := '287B747269676765725461726765743A617D297D2C753D672879292C797D2C462E64656C65676174653D66756E6374696F6E28742C65297B766172206E3D5B5D2C6F3D5B5D2C693D21312C613D652E7461726765742C733D7028652C5B22746172676574';
wwv_flow_api.g_varchar2_table(243) := '225D292C753D4F626A6563742E61737369676E287B7D2C732C7B747269676765723A226D616E75616C222C746F7563683A21317D292C663D4F626A6563742E61737369676E287B746F7563683A522E746F7563687D2C732C7B73686F774F6E4372656174';
wwv_flow_api.g_varchar2_table(244) := '653A21307D292C6C3D4628742C75293B66756E6374696F6E20642874297B696628742E74617267657426262169297B766172206E3D742E7461726765742E636C6F736573742861293B6966286E297B76617220723D6E2E67657441747472696275746528';
wwv_flow_api.g_varchar2_table(245) := '22646174612D74697070792D7472696767657222297C7C652E747269676765727C7C522E747269676765723B696628216E2E5F74697070792626212822746F7563687374617274223D3D3D742E74797065262622626F6F6C65616E223D3D747970656F66';
wwv_flow_api.g_varchar2_table(246) := '20662E746F7563687C7C22746F756368737461727422213D3D742E747970652626722E696E6465784F6628585B742E747970655D293C3029297B76617220733D46286E2C66293B732626286F3D6F2E636F6E636174287329297D7D7D7D66756E6374696F';
wwv_flow_api.g_varchar2_table(247) := '6E207628742C652C722C6F297B766F696420303D3D3D6F2626286F3D2131292C742E6164644576656E744C697374656E657228652C722C6F292C6E2E70757368287B6E6F64653A742C6576656E74547970653A652C68616E646C65723A722C6F7074696F';
wwv_flow_api.g_varchar2_table(248) := '6E733A6F7D297D72657475726E2063286C292E666F7245616368282866756E6374696F6E2874297B76617220653D742E64657374726F792C613D742E656E61626C652C733D742E64697361626C653B742E64657374726F793D66756E6374696F6E287429';
wwv_flow_api.g_varchar2_table(249) := '7B766F696420303D3D3D74262628743D2130292C7426266F2E666F7245616368282866756E6374696F6E2874297B742E64657374726F7928297D29292C6F3D5B5D2C6E2E666F7245616368282866756E6374696F6E2874297B76617220653D742E6E6F64';
wwv_flow_api.g_varchar2_table(250) := '652C6E3D742E6576656E74547970652C723D742E68616E646C65722C6F3D742E6F7074696F6E733B652E72656D6F76654576656E744C697374656E6572286E2C722C6F297D29292C6E3D5B5D2C6528297D2C742E656E61626C653D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(251) := '297B6128292C6F2E666F7245616368282866756E6374696F6E2874297B72657475726E20742E656E61626C6528297D29292C693D21317D2C742E64697361626C653D66756E6374696F6E28297B7328292C6F2E666F7245616368282866756E6374696F6E';
wwv_flow_api.g_varchar2_table(252) := '2874297B72657475726E20742E64697361626C6528297D29292C693D21307D2C66756E6374696F6E2874297B76617220653D742E7265666572656E63653B7628652C22746F7563687374617274222C642C72292C7628652C226D6F7573656F766572222C';
wwv_flow_api.g_varchar2_table(253) := '64292C7628652C22666F637573696E222C64292C7628652C22636C69636B222C64297D2874297D29292C6C7D2C462E68696465416C6C3D66756E6374696F6E2874297B76617220653D766F696420303D3D3D743F7B7D3A742C6E3D652E6578636C756465';
wwv_flow_api.g_varchar2_table(254) := '2C723D652E6475726174696F6E3B5F2E666F7245616368282866756E6374696F6E2874297B76617220653D21313B6966286E262628653D62286E293F742E7265666572656E63653D3D3D6E3A742E706F707065723D3D3D6E2E706F70706572292C216529';
wwv_flow_api.g_varchar2_table(255) := '7B766172206F3D742E70726F70732E6475726174696F6E3B742E73657450726F7073287B6475726174696F6E3A727D292C742E6869646528292C742E73746174652E697344657374726F7965647C7C742E73657450726F7073287B6475726174696F6E3A';
wwv_flow_api.g_varchar2_table(256) := '6F7D297D7D29297D2C462E726F756E644172726F773D273C7376672077696474683D22313622206865696768743D22362220786D6C6E733D22687474703A2F2F7777772E77332E6F72672F323030302F737667223E3C7061746820643D224D3020367331';
wwv_flow_api.g_varchar2_table(257) := '2E3739362D2E30313320342E36372D332E36313543352E3835312E3920362E39332E3030362038203063312E30372D2E30303620322E3134382E38383720332E33343320322E3338354331342E32333320362E3030352031362036203136203648307A22';
wwv_flow_api.g_varchar2_table(258) := '3E3C2F7376673E272C467D29293B0A2F2F2320736F757263654D617070696E6755524C3D74697070792D62756E646C652E756D642E6D696E2E6A732E6D61700A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(212707944441275706)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'libraries/tippy/tippy-bundle.umd.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D2766616465275D5B646174612D73746174653D2768696464656E275D207B0A09206F7061636974793A20303B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215303214080836363)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/fade.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D666164655D5B646174612D73746174653D68696464656E5D7B6F7061636974793A307D0A2F2A2320736F757263654D617070696E6755524C3D666164652E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215304076036836661)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/fade.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22666164652E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C6B442C434143452C53222C2266696C65223A22666164652E637373222C22736F75726365';
wwv_flow_api.g_varchar2_table(2) := '73436F6E74656E74223A5B222E74697070792D626F785B646174612D616E696D6174696F6E3D2766616465275D5B646174612D73746174653D2768696464656E275D207B5C6E5C74206F7061636974793A20303B5C6E7D225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215304443682836664)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/fade.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D207B0A09206F7061636974793A20303B0A7D0A202E74697070792D626F785B646174612D616E';
wwv_flow_api.g_varchar2_table(2) := '696D6174696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D22746F70225D207B0A09207472616E73666F726D3A207472616E736C61746559282D3130707829';
wwv_flow_api.g_varchar2_table(3) := '3B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D22626F74746F6D225D207B0A09207472';
wwv_flow_api.g_varchar2_table(4) := '616E73666F726D3A207472616E736C617465592831307078293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D5B646174612D706C';
wwv_flow_api.g_varchar2_table(5) := '6163656D656E745E3D226C656674225D207B0A09207472616E73666F726D3A207472616E736C61746558282D31307078293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D746F77617264275D5B64617461';
wwv_flow_api.g_varchar2_table(6) := '2D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D227269676874225D207B0A09207472616E73666F726D3A207472616E736C617465582831307078293B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215306674364842767)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/shift-toward.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;

wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D7B6F7061636974793A307D2E74697070792D626F785B646174612D616E696D6174696F6E3D7368696674';
wwv_flow_api.g_varchar2_table(2) := '2D746F776172645D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D746F705D7B7472616E73666F726D3A7472616E736C61746559282D31307078297D2E74697070792D626F785B646174612D616E696D617469';
wwv_flow_api.g_varchar2_table(3) := '6F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D626F74746F6D5D7B7472616E73666F726D3A7472616E736C617465592831307078297D2E74697070792D626F785B6461';
wwv_flow_api.g_varchar2_table(4) := '74612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D6C6566745D7B7472616E73666F726D3A7472616E736C61746558282D31307078297D2E746970';
wwv_flow_api.g_varchar2_table(5) := '70792D626F785B646174612D616E696D6174696F6E3D73686966742D746F776172645D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D72696768745D7B7472616E73666F726D3A7472616E736C617465582831';
wwv_flow_api.g_varchar2_table(6) := '307078297D0A2F2A2320736F757263654D617070696E6755524C3D73686966742D746F776172642E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215307401801842944)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/shift-toward.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B2273686966742D746F776172642E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C30442C434143452C532C434145442C2B452C434143432C32422C4341';
wwv_flow_api.g_varchar2_table(2) := '45442C6B462C434143432C30422C434145442C67462C434143432C32422C434145442C69462C434143432C3042222C2266696C65223A2273686966742D746F776172642E637373222C22736F7572636573436F6E74656E74223A5B222E74697070792D62';
wwv_flow_api.g_varchar2_table(3) := '6F785B646174612D616E696D6174696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D207B5C6E5C74206F7061636974793A20303B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174';
wwv_flow_api.g_varchar2_table(4) := '696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D5C22746F705C225D207B5C6E5C74207472616E73666F726D3A207472616E736C61746559282D3130707829';
wwv_flow_api.g_varchar2_table(5) := '3B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D5C22626F74746F6D5C225D207B5C';
wwv_flow_api.g_varchar2_table(6) := '6E5C74207472616E73666F726D3A207472616E736C617465592831307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D746F77617264275D5B646174612D73746174653D2768696464656E275D';
wwv_flow_api.g_varchar2_table(7) := '5B646174612D706C6163656D656E745E3D5C226C6566745C225D207B5C6E5C74207472616E73666F726D3A207472616E736C61746558282D31307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277368696674';
wwv_flow_api.g_varchar2_table(8) := '2D746F77617264275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D5C2272696768745C225D207B5C6E5C74207472616E73666F726D3A207472616E736C617465582831307078293B5C6E7D225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215307879985842947)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/shift-toward.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D227363616C65225D5B646174612D706C6163656D656E745E3D22746F70225D207B0A20207472616E73666F726D2D6F726967696E3A20626F74746F6D3B0A7D0A2E74697070792D626F78';
wwv_flow_api.g_varchar2_table(2) := '5B646174612D616E696D6174696F6E3D227363616C65225D5B646174612D706C6163656D656E745E3D22626F74746F6D225D207B0A20207472616E73666F726D2D6F726967696E3A20746F703B0A7D0A2E74697070792D626F785B646174612D616E696D';
wwv_flow_api.g_varchar2_table(3) := '6174696F6E3D227363616C65225D5B646174612D706C6163656D656E745E3D226C656674225D207B0A20207472616E73666F726D2D6F726967696E3A2072696768743B0A7D0A2E74697070792D626F785B646174612D616E696D6174696F6E3D22736361';
wwv_flow_api.g_varchar2_table(4) := '6C65225D5B646174612D706C6163656D656E745E3D227269676874225D207B0A20207472616E73666F726D2D6F726967696E3A206C6566743B0A7D0A2E74697070792D626F785B646174612D616E696D6174696F6E3D227363616C65225D5B646174612D';
wwv_flow_api.g_varchar2_table(5) := '73746174653D2268696464656E225D207B0A20207472616E73666F726D3A207363616C6528302E35293B0A20206F7061636974793A20303B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215308308164844652)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/scale.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D7363616C655D5B646174612D706C6163656D656E745E3D746F705D7B7472616E73666F726D2D6F726967696E3A626F74746F6D7D2E74697070792D626F785B646174612D616E696D6174';
wwv_flow_api.g_varchar2_table(2) := '696F6E3D7363616C655D5B646174612D706C6163656D656E745E3D626F74746F6D5D7B7472616E73666F726D2D6F726967696E3A746F707D2E74697070792D626F785B646174612D616E696D6174696F6E3D7363616C655D5B646174612D706C6163656D';
wwv_flow_api.g_varchar2_table(3) := '656E745E3D6C6566745D7B7472616E73666F726D2D6F726967696E3A72696768747D2E74697070792D626F785B646174612D616E696D6174696F6E3D7363616C655D5B646174612D706C6163656D656E745E3D72696768745D7B7472616E73666F726D2D';
wwv_flow_api.g_varchar2_table(4) := '6F726967696E3A6C6566747D2E74697070792D626F785B646174612D616E696D6174696F6E3D7363616C655D5B646174612D73746174653D68696464656E5D7B7472616E73666F726D3A7363616C65282E35293B6F7061636974793A307D0A2F2A232073';
wwv_flow_api.g_varchar2_table(5) := '6F757263654D617070696E6755524C3D7363616C652E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215309152032844884)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/scale.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B227363616C652E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C71442C434143452C75422C434145462C77442C434143452C6F422C434145462C73442C';
wwv_flow_api.g_varchar2_table(2) := '434143452C73422C434145462C75442C434143452C71422C434145462C6D442C434143452C6D422C434143412C53222C2266696C65223A227363616C652E637373222C22736F7572636573436F6E74656E74223A5B222E74697070792D626F785B646174';
wwv_flow_api.g_varchar2_table(3) := '612D616E696D6174696F6E3D5C227363616C655C225D5B646174612D706C6163656D656E745E3D5C22746F705C225D207B5C6E20207472616E73666F726D2D6F726967696E3A20626F74746F6D3B5C6E7D5C6E2E74697070792D626F785B646174612D61';
wwv_flow_api.g_varchar2_table(4) := '6E696D6174696F6E3D5C227363616C655C225D5B646174612D706C6163656D656E745E3D5C22626F74746F6D5C225D207B5C6E20207472616E73666F726D2D6F726967696E3A20746F703B5C6E7D5C6E2E74697070792D626F785B646174612D616E696D';
wwv_flow_api.g_varchar2_table(5) := '6174696F6E3D5C227363616C655C225D5B646174612D706C6163656D656E745E3D5C226C6566745C225D207B5C6E20207472616E73666F726D2D6F726967696E3A2072696768743B5C6E7D5C6E2E74697070792D626F785B646174612D616E696D617469';
wwv_flow_api.g_varchar2_table(6) := '6F6E3D5C227363616C655C225D5B646174612D706C6163656D656E745E3D5C2272696768745C225D207B5C6E20207472616E73666F726D2D6F726967696E3A206C6566743B5C6E7D5C6E2E74697070792D626F785B646174612D616E696D6174696F6E3D';
wwv_flow_api.g_varchar2_table(7) := '5C227363616C655C225D5B646174612D73746174653D5C2268696464656E5C225D207B5C6E20207472616E73666F726D3A207363616C6528302E35293B5C6E20206F7061636974793A20303B5C6E7D5C6E225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215309523584844888)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/scale.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D22746F70225D207B0A09207472616E73666F726D2D6F726967696E3A20626F74746F6D3B0A7D0A202E7469';
wwv_flow_api.g_varchar2_table(2) := '7070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D22746F70225D5B646174612D73746174653D2776697369626C65275D207B0A09207472616E73666F726D3A207065';
wwv_flow_api.g_varchar2_table(3) := '727370656374697665283730307078293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D22746F70225D5B646174612D73746174653D27686964';
wwv_flow_api.g_varchar2_table(4) := '64656E275D207B0A09207472616E73666F726D3A20706572737065637469766528373030707829207472616E736C61746559283870782920726F7461746558283630646567293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E';
wwv_flow_api.g_varchar2_table(5) := '3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D22626F74746F6D225D207B0A09207472616E73666F726D2D6F726967696E3A20746F703B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D2770';
wwv_flow_api.g_varchar2_table(6) := '65727370656374697665275D5B646174612D706C6163656D656E745E3D22626F74746F6D225D5B646174612D73746174653D2776697369626C65275D207B0A09207472616E73666F726D3A207065727370656374697665283730307078293B0A7D0A202E';
wwv_flow_api.g_varchar2_table(7) := '74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D22626F74746F6D225D5B646174612D73746174653D2768696464656E275D207B0A09207472616E73666F726D';
wwv_flow_api.g_varchar2_table(8) := '3A20706572737065637469766528373030707829207472616E736C61746559282D3870782920726F7461746558282D3630646567293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B64';
wwv_flow_api.g_varchar2_table(9) := '6174612D706C6163656D656E745E3D226C656674225D207B0A09207472616E73666F726D2D6F726967696E3A2072696768743B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B64617461';
wwv_flow_api.g_varchar2_table(10) := '2D706C6163656D656E745E3D226C656674225D5B646174612D73746174653D2776697369626C65275D207B0A09207472616E73666F726D3A207065727370656374697665283730307078293B0A7D0A202E74697070792D626F785B646174612D616E696D';
wwv_flow_api.g_varchar2_table(11) := '6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D226C656674225D5B646174612D73746174653D2768696464656E275D207B0A09207472616E73666F726D3A2070657273706563746976652837303070782920';
wwv_flow_api.g_varchar2_table(12) := '7472616E736C61746558283870782920726F7461746559282D3630646567293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D22726967687422';
wwv_flow_api.g_varchar2_table(13) := '5D207B0A09207472616E73666F726D2D6F726967696E3A206C6566743B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D227269676874225D5B64';
wwv_flow_api.g_varchar2_table(14) := '6174612D73746174653D2776697369626C65275D207B0A09207472616E73666F726D3A207065727370656374697665283730307078293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B';
wwv_flow_api.g_varchar2_table(15) := '646174612D706C6163656D656E745E3D227269676874225D5B646174612D73746174653D2768696464656E275D207B0A09207472616E73666F726D3A20706572737065637469766528373030707829207472616E736C61746558282D3870782920726F74';
wwv_flow_api.g_varchar2_table(16) := '61746559283630646567293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D73746174653D2768696464656E275D207B0A09206F7061636974793A20303B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215310025287849151)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/perspective.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D2768696464656E275D207B0A09206F7061636974793A20303B0A7D0A202E74697070792D626F785B646174612D616E696D';
wwv_flow_api.g_varchar2_table(2) := '6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D22746F70225D207B0A09207472616E73666F726D3A207472616E736C617465592831307078293B0A7D0A20';
wwv_flow_api.g_varchar2_table(3) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D22626F74746F6D225D207B0A09207472616E73666F726D';
wwv_flow_api.g_varchar2_table(4) := '3A207472616E736C61746559282D31307078293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E';
wwv_flow_api.g_varchar2_table(5) := '3D226C656674225D207B0A09207472616E73666F726D3A207472616E736C617465582831307078293B0A7D0A202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D27686964';
wwv_flow_api.g_varchar2_table(6) := '64656E275D5B646174612D706C6163656D656E745E3D227269676874225D207B0A09207472616E73666F726D3A207472616E736C61746558282D31307078293B0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215311479667888933)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/shift-away.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D7B6F7061636974793A307D2E74697070792D626F785B646174612D616E696D6174696F6E3D73686966742D61';
wwv_flow_api.g_varchar2_table(2) := '7761795D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D746F705D7B7472616E73666F726D3A7472616E736C617465592831307078297D2E74697070792D626F785B646174612D616E696D6174696F6E3D7368';
wwv_flow_api.g_varchar2_table(3) := '6966742D617761795D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D626F74746F6D5D7B7472616E73666F726D3A7472616E736C61746559282D31307078297D2E74697070792D626F785B646174612D616E69';
wwv_flow_api.g_varchar2_table(4) := '6D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D6C6566745D7B7472616E73666F726D3A7472616E736C617465582831307078297D2E74697070792D626F785B6461';
wwv_flow_api.g_varchar2_table(5) := '74612D616E696D6174696F6E3D73686966742D617761795D5B646174612D73746174653D68696464656E5D5B646174612D706C6163656D656E745E3D72696768745D7B7472616E73666F726D3A7472616E736C61746558282D31307078297D0A2F2A2320';
wwv_flow_api.g_varchar2_table(6) := '736F757263654D617070696E6755524C3D73686966742D617761792E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215312238365891133)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/shift-away.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B2273686966742D617761792E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C77442C434143452C532C434145442C36452C434143432C30422C43414544';
wwv_flow_api.g_varchar2_table(2) := '2C67462C434143432C32422C434145442C38452C434143432C30422C434145442C2B452C434143432C3242222C2266696C65223A2273686966742D617761792E637373222C22736F7572636573436F6E74656E74223A5B222E74697070792D626F785B64';
wwv_flow_api.g_varchar2_table(3) := '6174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D2768696464656E275D207B5C6E5C74206F7061636974793A20303B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D2773';
wwv_flow_api.g_varchar2_table(4) := '686966742D61776179275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D5C22746F705C225D207B5C6E5C74207472616E73666F726D3A207472616E736C617465592831307078293B5C6E7D5C6E202E74';
wwv_flow_api.g_varchar2_table(5) := '697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D5C22626F74746F6D5C225D207B5C6E5C74207472616E73666F';
wwv_flow_api.g_varchar2_table(6) := '726D3A207472616E736C61746559282D31307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D73746174653D2768696464656E275D5B646174612D706C6163656D';
wwv_flow_api.g_varchar2_table(7) := '656E745E3D5C226C6566745C225D207B5C6E5C74207472616E73666F726D3A207472616E736C617465582831307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D2773686966742D61776179275D5B646174612D';
wwv_flow_api.g_varchar2_table(8) := '73746174653D2768696464656E275D5B646174612D706C6163656D656E745E3D5C2272696768745C225D207B5C6E5C74207472616E73666F726D3A207472616E736C61746558282D31307078293B5C6E7D225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215312625746891136)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/shift-away.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F78207B0A2020626F726465723A20317078207472616E73706172656E743B0A7D0A2E74697070792D626F785B646174612D706C6163656D656E745E3D22746F70225D203E202E74697070792D6172726F773A6166746572207B0A20';
wwv_flow_api.g_varchar2_table(2) := '20626F726465722D746F702D636F6C6F723A20696E68657269743B0A2020626F726465722D77696474683A203870782038707820303B0A2020626F74746F6D3A202D3870783B0A20206C6566743A20303B0A7D0A2E74697070792D626F785B646174612D';
wwv_flow_api.g_varchar2_table(3) := '706C6163656D656E745E3D22626F74746F6D225D203E202E74697070792D6172726F773A6166746572207B0A2020626F726465722D626F74746F6D2D636F6C6F723A20696E68657269743B0A2020626F726465722D77696474683A203020387078203870';
wwv_flow_api.g_varchar2_table(4) := '783B0A2020746F703A202D3870783B0A20206C6566743A20303B0A7D0A2E74697070792D626F785B646174612D706C6163656D656E745E3D226C656674225D203E202E74697070792D6172726F773A6166746572207B0A2020626F726465722D6C656674';
wwv_flow_api.g_varchar2_table(5) := '2D636F6C6F723A20696E68657269743B0A2020626F726465722D77696474683A20387078203020387078203870783B0A202072696768743A202D3870783B0A2020746F703A20303B0A7D0A2E74697070792D626F785B646174612D706C6163656D656E74';
wwv_flow_api.g_varchar2_table(6) := '5E3D227269676874225D203E202E74697070792D6172726F773A6166746572207B0A2020626F726465722D77696474683A20387078203870782038707820303B0A20206C6566743A202D3870783B0A2020746F703A20303B0A2020626F726465722D7269';
wwv_flow_api.g_varchar2_table(7) := '6768742D636F6C6F723A20696E68657269743B0A7D0A2E74697070792D626F785B646174612D706C6163656D656E745E3D22746F70225D0A20203E202E74697070792D7376672D6172726F770A20203E207376673A66697273742D6368696C643A6E6F74';
wwv_flow_api.g_varchar2_table(8) := '283A6C6173742D6368696C6429207B0A2020746F703A20313770783B0A7D0A2E74697070792D626F785B646174612D706C6163656D656E745E3D22626F74746F6D225D0A20203E202E74697070792D7376672D6172726F770A20203E207376673A666972';
wwv_flow_api.g_varchar2_table(9) := '73742D6368696C643A6E6F74283A6C6173742D6368696C6429207B0A2020626F74746F6D3A20313770783B0A7D0A2E74697070792D626F785B646174612D706C6163656D656E745E3D226C656674225D0A20203E202E74697070792D7376672D6172726F';
wwv_flow_api.g_varchar2_table(10) := '770A20203E207376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C6429207B0A20206C6566743A20313270783B0A7D0A2E74697070792D626F785B646174612D706C6163656D656E745E3D227269676874225D0A20203E202E7469';
wwv_flow_api.g_varchar2_table(11) := '7070792D7376672D6172726F770A20203E207376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C6429207B0A202072696768743A20313270783B0A7D0A2E74697070792D6172726F77207B0A2020626F726465722D636F6C6F723A';
wwv_flow_api.g_varchar2_table(12) := '20696E68657269743B0A7D0A2E74697070792D6172726F773A6166746572207B0A2020636F6E74656E743A2022223B0A20207A2D696E6465783A202D313B0A2020706F736974696F6E3A206162736F6C7574653B0A2020626F726465722D636F6C6F723A';
wwv_flow_api.g_varchar2_table(13) := '207472616E73706172656E743B0A2020626F726465722D7374796C653A20736F6C69643B0A7D0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215317256060973003)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/border.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F787B626F726465723A317078207472616E73706172656E747D2E74697070792D626F785B646174612D706C6163656D656E745E3D746F705D3E2E74697070792D6172726F773A61667465727B626F726465722D746F702D636F6C6F';
wwv_flow_api.g_varchar2_table(2) := '723A696E68657269743B626F726465722D77696474683A3870782038707820303B626F74746F6D3A2D3870783B6C6566743A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D626F74746F6D5D3E2E74697070792D6172726F773A';
wwv_flow_api.g_varchar2_table(3) := '61667465727B626F726465722D626F74746F6D2D636F6C6F723A696E68657269743B626F726465722D77696474683A3020387078203870783B746F703A2D3870783B6C6566743A307D2E74697070792D626F785B646174612D706C6163656D656E745E3D';
wwv_flow_api.g_varchar2_table(4) := '6C6566745D3E2E74697070792D6172726F773A61667465727B626F726465722D6C6566742D636F6C6F723A696E68657269743B626F726465722D77696474683A387078203020387078203870783B72696768743A2D3870783B746F703A307D2E74697070';
wwv_flow_api.g_varchar2_table(5) := '792D626F785B646174612D706C6163656D656E745E3D72696768745D3E2E74697070792D6172726F773A61667465727B626F726465722D77696474683A387078203870782038707820303B6C6566743A2D3870783B746F703A303B626F726465722D7269';
wwv_flow_api.g_varchar2_table(6) := '6768742D636F6C6F723A696E68657269747D2E74697070792D626F785B646174612D706C6163656D656E745E3D746F705D3E2E74697070792D7376672D6172726F773E7376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C64297B';
wwv_flow_api.g_varchar2_table(7) := '746F703A313770787D2E74697070792D626F785B646174612D706C6163656D656E745E3D626F74746F6D5D3E2E74697070792D7376672D6172726F773E7376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C64297B626F74746F6D';
wwv_flow_api.g_varchar2_table(8) := '3A313770787D2E74697070792D626F785B646174612D706C6163656D656E745E3D6C6566745D3E2E74697070792D7376672D6172726F773E7376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C64297B6C6566743A313270787D2E';
wwv_flow_api.g_varchar2_table(9) := '74697070792D626F785B646174612D706C6163656D656E745E3D72696768745D3E2E74697070792D7376672D6172726F773E7376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C64297B72696768743A313270787D2E7469707079';
wwv_flow_api.g_varchar2_table(10) := '2D6172726F777B626F726465722D636F6C6F723A696E68657269747D2E74697070792D6172726F773A61667465727B636F6E74656E743A22223B7A2D696E6465783A2D313B706F736974696F6E3A6162736F6C7574653B626F726465722D636F6C6F723A';
wwv_flow_api.g_varchar2_table(11) := '7472616E73706172656E743B626F726465722D7374796C653A736F6C69647D0A2F2A2320736F757263654D617070696E6755524C3D626F726465722E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215318015051973250)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/border.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B22626F726465722E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C552C434143452C73422C434145462C6B442C434143452C77422C434143412C73422C';
wwv_flow_api.g_varchar2_table(2) := '434143412C572C434143412C4D2C434145462C71442C434143452C32422C434143412C73422C434143412C512C434143412C4D2C434145462C6D442C434143452C79422C434143412C30422C434143412C552C434143412C4B2C434145462C6F442C4341';
wwv_flow_api.g_varchar2_table(3) := '43452C30422C434143412C532C434143412C4B2C434143412C30422C434145462C7145414577422C592C43414374422C512C434145462C7745414577422C592C43414374422C572C434145462C7345414577422C592C43414374422C532C434145462C75';
wwv_flow_api.g_varchar2_table(4) := '45414577422C592C43414374422C552C434145462C592C434143452C6F422C434145462C6B422C434143452C552C434143412C552C434143412C69422C434143412C77422C434143412C6B42222C2266696C65223A22626F726465722E637373222C2273';
wwv_flow_api.g_varchar2_table(5) := '6F7572636573436F6E74656E74223A5B222E74697070792D626F78207B5C6E2020626F726465723A20317078207472616E73706172656E743B5C6E7D5C6E2E74697070792D626F785B646174612D706C6163656D656E745E3D5C22746F705C225D203E20';
wwv_flow_api.g_varchar2_table(6) := '2E74697070792D6172726F773A6166746572207B5C6E2020626F726465722D746F702D636F6C6F723A20696E68657269743B5C6E2020626F726465722D77696474683A203870782038707820303B5C6E2020626F74746F6D3A202D3870783B5C6E20206C';
wwv_flow_api.g_varchar2_table(7) := '6566743A20303B5C6E7D5C6E2E74697070792D626F785B646174612D706C6163656D656E745E3D5C22626F74746F6D5C225D203E202E74697070792D6172726F773A6166746572207B5C6E2020626F726465722D626F74746F6D2D636F6C6F723A20696E';
wwv_flow_api.g_varchar2_table(8) := '68657269743B5C6E2020626F726465722D77696474683A203020387078203870783B5C6E2020746F703A202D3870783B5C6E20206C6566743A20303B5C6E7D5C6E2E74697070792D626F785B646174612D706C6163656D656E745E3D5C226C6566745C22';
wwv_flow_api.g_varchar2_table(9) := '5D203E202E74697070792D6172726F773A6166746572207B5C6E2020626F726465722D6C6566742D636F6C6F723A20696E68657269743B5C6E2020626F726465722D77696474683A20387078203020387078203870783B5C6E202072696768743A202D38';
wwv_flow_api.g_varchar2_table(10) := '70783B5C6E2020746F703A20303B5C6E7D5C6E2E74697070792D626F785B646174612D706C6163656D656E745E3D5C2272696768745C225D203E202E74697070792D6172726F773A6166746572207B5C6E2020626F726465722D77696474683A20387078';
wwv_flow_api.g_varchar2_table(11) := '203870782038707820303B5C6E20206C6566743A202D3870783B5C6E2020746F703A20303B5C6E2020626F726465722D72696768742D636F6C6F723A20696E68657269743B5C6E7D5C6E2E74697070792D626F785B646174612D706C6163656D656E745E';
wwv_flow_api.g_varchar2_table(12) := '3D5C22746F705C225D5C6E20203E202E74697070792D7376672D6172726F775C6E20203E207376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C6429207B5C6E2020746F703A20313770783B5C6E7D5C6E2E74697070792D626F78';
wwv_flow_api.g_varchar2_table(13) := '5B646174612D706C6163656D656E745E3D5C22626F74746F6D5C225D5C6E20203E202E74697070792D7376672D6172726F775C6E20203E207376673A66697273742D6368696C643A6E6F74283A6C6173742D6368696C6429207B5C6E2020626F74746F6D';
wwv_flow_api.g_varchar2_table(14) := '3A20313770783B5C6E7D5C6E2E74697070792D626F785B646174612D706C6163656D656E745E3D5C226C6566745C225D5C6E20203E202E74697070792D7376672D6172726F775C6E20203E207376673A66697273742D6368696C643A6E6F74283A6C6173';
wwv_flow_api.g_varchar2_table(15) := '742D6368696C6429207B5C6E20206C6566743A20313270783B5C6E7D5C6E2E74697070792D626F785B646174612D706C6163656D656E745E3D5C2272696768745C225D5C6E20203E202E74697070792D7376672D6172726F775C6E20203E207376673A66';
wwv_flow_api.g_varchar2_table(16) := '697273742D6368696C643A6E6F74283A6C6173742D6368696C6429207B5C6E202072696768743A20313270783B5C6E7D5C6E2E74697070792D6172726F77207B5C6E2020626F726465722D636F6C6F723A20696E68657269743B5C6E7D5C6E2E74697070';
wwv_flow_api.g_varchar2_table(17) := '792D6172726F773A6166746572207B5C6E2020636F6E74656E743A205C225C223B5C6E20207A2D696E6465783A202D313B5C6E2020706F736974696F6E3A206162736F6C7574653B5C6E2020626F726465722D636F6C6F723A207472616E73706172656E';
wwv_flow_api.g_varchar2_table(18) := '743B5C6E2020626F726465722D7374796C653A20736F6C69643B5C6E7D5C6E225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215318488140973253)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/border.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;

wwv_flow_api.g_varchar2_table(1) := '2F2A2A0A202A2040706F707065726A732F636F72652076322E392E30202D204D4954204C6963656E73650A202A2F0A0A2275736520737472696374223B2166756E6374696F6E28652C74297B226F626A656374223D3D747970656F66206578706F727473';
wwv_flow_api.g_varchar2_table(2) := '262622756E646566696E656422213D747970656F66206D6F64756C653F74286578706F727473293A2266756E6374696F6E223D3D747970656F6620646566696E652626646566696E652E616D643F646566696E65285B226578706F727473225D2C74293A';
wwv_flow_api.g_varchar2_table(3) := '742828653D22756E646566696E656422213D747970656F6620676C6F62616C546869733F676C6F62616C546869733A657C7C73656C66292E506F707065723D7B7D297D28746869732C2866756E6374696F6E2865297B66756E6374696F6E20742865297B';
wwv_flow_api.g_varchar2_table(4) := '72657475726E7B77696474683A28653D652E676574426F756E64696E67436C69656E74526563742829292E77696474682C6865696768743A652E6865696768742C746F703A652E746F702C72696768743A652E72696768742C626F74746F6D3A652E626F';
wwv_flow_api.g_varchar2_table(5) := '74746F6D2C6C6566743A652E6C6566742C783A652E6C6566742C793A652E746F707D7D66756E6374696F6E206E2865297B72657475726E206E756C6C3D3D653F77696E646F773A225B6F626A6563742057696E646F775D22213D3D652E746F537472696E';
wwv_flow_api.g_varchar2_table(6) := '6728293F28653D652E6F776E6572446F63756D656E74292626652E64656661756C74566965777C7C77696E646F773A657D66756E6374696F6E206F2865297B72657475726E7B7363726F6C6C4C6566743A28653D6E286529292E70616765584F66667365';
wwv_flow_api.g_varchar2_table(7) := '742C7363726F6C6C546F703A652E70616765594F66667365747D7D66756E6374696F6E20722865297B72657475726E206520696E7374616E63656F66206E2865292E456C656D656E747C7C6520696E7374616E63656F6620456C656D656E747D66756E63';
wwv_flow_api.g_varchar2_table(8) := '74696F6E20692865297B72657475726E206520696E7374616E63656F66206E2865292E48544D4C456C656D656E747C7C6520696E7374616E63656F662048544D4C456C656D656E747D66756E6374696F6E20612865297B72657475726E22756E64656669';
wwv_flow_api.g_varchar2_table(9) := '6E656422213D747970656F6620536861646F77526F6F742626286520696E7374616E63656F66206E2865292E536861646F77526F6F747C7C6520696E7374616E63656F6620536861646F77526F6F74297D66756E6374696F6E20732865297B7265747572';
wwv_flow_api.g_varchar2_table(10) := '6E20653F28652E6E6F64654E616D657C7C2222292E746F4C6F7765724361736528293A6E756C6C7D66756E6374696F6E20662865297B72657475726E2828722865293F652E6F776E6572446F63756D656E743A652E646F63756D656E74297C7C77696E64';
wwv_flow_api.g_varchar2_table(11) := '6F772E646F63756D656E74292E646F63756D656E74456C656D656E747D66756E6374696F6E20702865297B72657475726E20742866286529292E6C6566742B6F2865292E7363726F6C6C4C6566747D66756E6374696F6E20632865297B72657475726E20';
wwv_flow_api.g_varchar2_table(12) := '6E2865292E676574436F6D70757465645374796C652865297D66756E6374696F6E206C2865297B72657475726E20653D632865292C2F6175746F7C7363726F6C6C7C6F7665726C61797C68696464656E2F2E7465737428652E6F766572666C6F772B652E';
wwv_flow_api.g_varchar2_table(13) := '6F766572666C6F77592B652E6F766572666C6F7758297D66756E6374696F6E207528652C722C61297B766F696420303D3D3D61262628613D2131293B76617220633D662872293B653D742865293B76617220753D692872292C643D7B7363726F6C6C4C65';
wwv_flow_api.g_varchar2_table(14) := '66743A302C7363726F6C6C546F703A307D2C6D3D7B783A302C793A307D3B72657475726E28757C7C217526262161292626282822626F647922213D3D732872297C7C6C28632929262628643D72213D3D6E2872292626692872293F7B7363726F6C6C4C65';
wwv_flow_api.g_varchar2_table(15) := '66743A722E7363726F6C6C4C6566742C7363726F6C6C546F703A722E7363726F6C6C546F707D3A6F287229292C692872293F28286D3D74287229292E782B3D722E636C69656E744C6566742C6D2E792B3D722E636C69656E74546F70293A632626286D2E';
wwv_flow_api.g_varchar2_table(16) := '783D7028632929292C7B783A652E6C6566742B642E7363726F6C6C4C6566742D6D2E782C793A652E746F702B642E7363726F6C6C546F702D6D2E792C77696474683A652E77696474682C6865696768743A652E6865696768747D7D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(17) := '642865297B766172206E3D742865292C6F3D652E6F666673657457696474682C723D652E6F66667365744865696768743B72657475726E20313E3D4D6174682E616273286E2E77696474682D6F292626286F3D6E2E7769647468292C313E3D4D6174682E';
wwv_flow_api.g_varchar2_table(18) := '616273286E2E6865696768742D7229262628723D6E2E686569676874292C7B783A652E6F66667365744C6566742C793A652E6F6666736574546F702C77696474683A6F2C6865696768743A727D7D66756E6374696F6E206D2865297B72657475726E2268';
wwv_flow_api.g_varchar2_table(19) := '746D6C223D3D3D732865293F653A652E61737369676E6564536C6F747C7C652E706172656E744E6F64657C7C28612865293F652E686F73743A6E756C6C297C7C662865297D66756E6374696F6E20682865297B72657475726E20303C3D5B2268746D6C22';
wwv_flow_api.g_varchar2_table(20) := '2C22626F6479222C2223646F63756D656E74225D2E696E6465784F662873286529293F652E6F776E6572446F63756D656E742E626F64793A6928652926266C2865293F653A68286D286529297D66756E6374696F6E207628652C74297B766172206F3B76';
wwv_flow_api.g_varchar2_table(21) := '6F696420303D3D3D74262628743D5B5D293B76617220723D682865293B72657475726E20653D723D3D3D286E756C6C3D3D286F3D652E6F776E6572446F63756D656E74293F766F696420303A6F2E626F6479292C6F3D6E2872292C723D653F5B6F5D2E63';
wwv_flow_api.g_varchar2_table(22) := '6F6E636174286F2E76697375616C56696577706F72747C7C5B5D2C6C2872293F723A5B5D293A722C743D742E636F6E6361742872292C653F743A742E636F6E6361742876286D28722929297D66756E6374696F6E20672865297B72657475726E20692865';
wwv_flow_api.g_varchar2_table(23) := '29262622666978656422213D3D632865292E706F736974696F6E3F652E6F6666736574506172656E743A6E756C6C7D66756E6374696F6E20792865297B666F722876617220743D6E2865292C6F3D672865293B6F2626303C3D5B227461626C65222C2274';
wwv_flow_api.g_varchar2_table(24) := '64222C227468225D2E696E6465784F662873286F2929262622737461746963223D3D3D63286F292E706F736974696F6E3B296F3D67286F293B6966286F2626282268746D6C223D3D3D73286F297C7C22626F6479223D3D3D73286F292626227374617469';
wwv_flow_api.g_varchar2_table(25) := '63223D3D3D63286F292E706F736974696F6E292972657475726E20743B696628216F29653A7B666F72286F3D6E6176696761746F722E757365724167656E742E746F4C6F7765724361736528292E696E636C75646573282266697265666F7822292C653D';
wwv_flow_api.g_varchar2_table(26) := '6D2865293B692865292626303E5B2268746D6C222C22626F6479225D2E696E6465784F662873286529293B297B76617220723D632865293B696628226E6F6E6522213D3D722E7472616E73666F726D7C7C226E6F6E6522213D3D722E7065727370656374';
wwv_flow_api.g_varchar2_table(27) := '6976657C7C227061696E74223D3D3D722E636F6E7461696E7C7C5B227472616E73666F726D222C227065727370656374697665225D2E696E636C7564657328722E77696C6C4368616E6765297C7C6F26262266696C746572223D3D3D722E77696C6C4368';
wwv_flow_api.g_varchar2_table(28) := '616E67657C7C6F2626722E66696C7465722626226E6F6E6522213D3D722E66696C746572297B6F3D653B627265616B20657D653D652E706172656E744E6F64657D6F3D6E756C6C7D72657475726E206F7C7C747D66756E6374696F6E20622865297B6675';
wwv_flow_api.g_varchar2_table(29) := '6E6374696F6E20742865297B6F2E61646428652E6E616D65292C5B5D2E636F6E63617428652E72657175697265737C7C5B5D2C652E726571756972657349664578697374737C7C5B5D292E666F7245616368282866756E6374696F6E2865297B6F2E6861';
wwv_flow_api.g_varchar2_table(30) := '732865297C7C28653D6E2E676574286529292626742865297D29292C722E707573682865297D766172206E3D6E6577204D61702C6F3D6E6577205365742C723D5B5D3B72657475726E20652E666F7245616368282866756E6374696F6E2865297B6E2E73';
wwv_flow_api.g_varchar2_table(31) := '657428652E6E616D652C65297D29292C652E666F7245616368282866756E6374696F6E2865297B6F2E68617328652E6E616D65297C7C742865297D29292C727D66756E6374696F6E20772865297B76617220743B72657475726E2066756E6374696F6E28';
wwv_flow_api.g_varchar2_table(32) := '297B72657475726E20747C7C28743D6E65772050726F6D697365282866756E6374696F6E286E297B50726F6D6973652E7265736F6C766528292E7468656E282866756E6374696F6E28297B743D766F696420302C6E28652829297D29297D2929292C747D';
wwv_flow_api.g_varchar2_table(33) := '7D66756E6374696F6E20782865297B72657475726E20652E73706C697428222D22295B305D7D66756E6374696F6E204F28652C74297B766172206E3D742E676574526F6F744E6F64652626742E676574526F6F744E6F646528293B696628652E636F6E74';
wwv_flow_api.g_varchar2_table(34) := '61696E732874292972657475726E21303B6966286E262661286E2929646F7B696628742626652E697353616D654E6F64652874292972657475726E21303B743D742E706172656E744E6F64657C7C742E686F73747D7768696C652874293B72657475726E';
wwv_flow_api.g_varchar2_table(35) := '21317D66756E6374696F6E206A2865297B72657475726E204F626A6563742E61737369676E287B7D2C652C7B6C6566743A652E782C746F703A652E792C72696768743A652E782B652E77696474682C626F74746F6D3A652E792B652E6865696768747D29';
wwv_flow_api.g_varchar2_table(36) := '7D66756E6374696F6E204528652C72297B6966282276696577706F7274223D3D3D72297B723D6E2865293B76617220613D662865293B723D722E76697375616C56696577706F72743B76617220733D612E636C69656E7457696474683B613D612E636C69';
wwv_flow_api.g_varchar2_table(37) := '656E744865696768743B766172206C3D302C753D303B72262628733D722E77696474682C613D722E6865696768742C2F5E28283F216368726F6D657C616E64726F6964292E292A7361666172692F692E74657374286E6176696761746F722E7573657241';
wwv_flow_api.g_varchar2_table(38) := '67656E74297C7C286C3D722E6F66667365744C6566742C753D722E6F6666736574546F7029292C653D6A28653D7B77696474683A732C6865696768743A612C783A6C2B702865292C793A757D297D656C736520692872293F2828653D74287229292E746F';
wwv_flow_api.g_varchar2_table(39) := '702B3D722E636C69656E74546F702C652E6C6566742B3D722E636C69656E744C6566742C652E626F74746F6D3D652E746F702B722E636C69656E744865696768742C652E72696768743D652E6C6566742B722E636C69656E7457696474682C652E776964';
wwv_flow_api.g_varchar2_table(40) := '74683D722E636C69656E7457696474682C652E6865696768743D722E636C69656E744865696768742C652E783D652E6C6566742C652E793D652E746F70293A28753D662865292C653D662875292C733D6F2875292C723D6E756C6C3D3D28613D752E6F77';
wwv_flow_api.g_varchar2_table(41) := '6E6572446F63756D656E74293F766F696420303A612E626F64792C613D5F28652E7363726F6C6C57696474682C652E636C69656E7457696474682C723F722E7363726F6C6C57696474683A302C723F722E636C69656E7457696474683A30292C6C3D5F28';
wwv_flow_api.g_varchar2_table(42) := '652E7363726F6C6C4865696768742C652E636C69656E744865696768742C723F722E7363726F6C6C4865696768743A302C723F722E636C69656E744865696768743A30292C753D2D732E7363726F6C6C4C6566742B702875292C733D2D732E7363726F6C';
wwv_flow_api.g_varchar2_table(43) := '6C546F702C2272746C223D3D3D6328727C7C65292E646972656374696F6E262628752B3D5F28652E636C69656E7457696474682C723F722E636C69656E7457696474683A30292D61292C653D6A287B77696474683A612C6865696768743A6C2C783A752C';
wwv_flow_api.g_varchar2_table(44) := '793A737D29293B72657475726E20657D66756E6374696F6E204428652C742C6E297B72657475726E20743D22636C697070696E67506172656E7473223D3D3D743F66756E6374696F6E2865297B76617220743D76286D286529292C6E3D303C3D5B226162';
wwv_flow_api.g_varchar2_table(45) := '736F6C757465222C226669786564225D2E696E6465784F6628632865292E706F736974696F6E292626692865293F792865293A653B72657475726E2072286E293F742E66696C746572282866756E6374696F6E2865297B72657475726E20722865292626';
wwv_flow_api.g_varchar2_table(46) := '4F28652C6E29262622626F647922213D3D732865297D29293A5B5D7D2865293A5B5D2E636F6E6361742874292C286E3D286E3D5B5D2E636F6E63617428742C5B6E5D29292E726564756365282866756E6374696F6E28742C6E297B72657475726E206E3D';
wwv_flow_api.g_varchar2_table(47) := '4528652C6E292C742E746F703D5F286E2E746F702C742E746F70292C742E72696768743D55286E2E72696768742C742E7269676874292C742E626F74746F6D3D55286E2E626F74746F6D2C742E626F74746F6D292C742E6C6566743D5F286E2E6C656674';
wwv_flow_api.g_varchar2_table(48) := '2C742E6C656674292C747D292C4528652C6E5B305D2929292E77696474683D6E2E72696768742D6E2E6C6566742C6E2E6865696768743D6E2E626F74746F6D2D6E2E746F702C6E2E783D6E2E6C6566742C6E2E793D6E2E746F702C6E7D66756E6374696F';
wwv_flow_api.g_varchar2_table(49) := '6E204C2865297B72657475726E20303C3D5B22746F70222C22626F74746F6D225D2E696E6465784F662865293F2278223A2279227D66756E6374696F6E20502865297B76617220743D652E7265666572656E63652C6E3D652E656C656D656E742C6F3D28';
wwv_flow_api.g_varchar2_table(50) := '653D652E706C6163656D656E74293F782865293A6E756C6C3B653D653F652E73706C697428222D22295B315D3A6E756C6C3B76617220723D742E782B742E77696474682F322D6E2E77696474682F322C693D742E792B742E6865696768742F322D6E2E68';
wwv_flow_api.g_varchar2_table(51) := '65696768742F323B737769746368286F297B6361736522746F70223A723D7B783A722C793A742E792D6E2E6865696768747D3B627265616B3B6361736522626F74746F6D223A723D7B783A722C793A742E792B742E6865696768747D3B627265616B3B63';
wwv_flow_api.g_varchar2_table(52) := '617365227269676874223A723D7B783A742E782B742E77696474682C793A697D3B627265616B3B63617365226C656674223A723D7B783A742E782D6E2E77696474682C793A697D3B627265616B3B64656661756C743A723D7B783A742E782C793A742E79';
wwv_flow_api.g_varchar2_table(53) := '7D7D6966286E756C6C213D286F3D6F3F4C286F293A6E756C6C292973776974636828693D2279223D3D3D6F3F22686569676874223A227769647468222C65297B63617365227374617274223A725B6F5D2D3D745B695D2F322D6E5B695D2F323B62726561';
wwv_flow_api.g_varchar2_table(54) := '6B3B6361736522656E64223A725B6F5D2B3D745B695D2F322D6E5B695D2F327D72657475726E20727D66756E6374696F6E204D2865297B72657475726E204F626A6563742E61737369676E287B7D2C7B746F703A302C72696768743A302C626F74746F6D';
wwv_flow_api.g_varchar2_table(55) := '3A302C6C6566743A307D2C65297D66756E6374696F6E206B28652C74297B72657475726E20742E726564756365282866756E6374696F6E28742C6E297B72657475726E20745B6E5D3D652C747D292C7B7D297D66756E6374696F6E205728652C6E297B76';
wwv_flow_api.g_varchar2_table(56) := '6F696420303D3D3D6E2626286E3D7B7D293B766172206F3D6E3B6E3D766F696420303D3D3D286E3D6F2E706C6163656D656E74293F652E706C6163656D656E743A6E3B76617220693D6F2E626F756E646172792C613D766F696420303D3D3D693F22636C';
wwv_flow_api.g_varchar2_table(57) := '697070696E67506172656E7473223A692C733D766F696420303D3D3D28693D6F2E726F6F74426F756E64617279293F2276696577706F7274223A693B693D766F696420303D3D3D28693D6F2E656C656D656E74436F6E74657874293F22706F7070657222';
wwv_flow_api.g_varchar2_table(58) := '3A693B76617220703D6F2E616C74426F756E646172792C633D766F69642030213D3D702626703B6F3D4D28226E756D62657222213D747970656F66286F3D766F696420303D3D3D286F3D6F2E70616464696E67293F303A6F293F6F3A6B286F2C4329293B';
wwv_flow_api.g_varchar2_table(59) := '766172206C3D652E656C656D656E74732E7265666572656E63653B703D652E72656374732E706F707065722C613D44287228633D652E656C656D656E74735B633F22706F70706572223D3D3D693F227265666572656E6365223A22706F70706572223A69';
wwv_flow_api.g_varchar2_table(60) := '5D293F633A632E636F6E74657874456C656D656E747C7C6628652E656C656D656E74732E706F70706572292C612C73292C633D50287B7265666572656E63653A733D74286C292C656C656D656E743A702C73747261746567793A226162736F6C75746522';
wwv_flow_api.g_varchar2_table(61) := '2C706C6163656D656E743A6E7D292C703D6A284F626A6563742E61737369676E287B7D2C702C6329292C733D22706F70706572223D3D3D693F703A733B76617220753D7B746F703A612E746F702D732E746F702B6F2E746F702C626F74746F6D3A732E62';
wwv_flow_api.g_varchar2_table(62) := '6F74746F6D2D612E626F74746F6D2B6F2E626F74746F6D2C6C6566743A612E6C6566742D732E6C6566742B6F2E6C6566742C72696768743A732E72696768742D612E72696768742B6F2E72696768747D3B696628653D652E6D6F64696669657273446174';
wwv_flow_api.g_varchar2_table(63) := '612E6F66667365742C22706F70706572223D3D3D69262665297B76617220643D655B6E5D3B4F626A6563742E6B6579732875292E666F7245616368282866756E6374696F6E2865297B76617220743D303C3D5B227269676874222C22626F74746F6D225D';
wwv_flow_api.g_varchar2_table(64) := '2E696E6465784F662865293F313A2D312C6E3D303C3D5B22746F70222C22626F74746F6D225D2E696E6465784F662865293F2279223A2278223B755B655D2B3D645B6E5D2A747D29297D72657475726E20757D66756E6374696F6E204128297B666F7228';
wwv_flow_api.g_varchar2_table(65) := '76617220653D617267756D656E74732E6C656E6774682C743D41727261792865292C6E3D303B6E3C653B6E2B2B29745B6E5D3D617267756D656E74735B6E5D3B72657475726E21742E736F6D65282866756E6374696F6E2865297B72657475726E212865';
wwv_flow_api.g_varchar2_table(66) := '26262266756E6374696F6E223D3D747970656F6620652E676574426F756E64696E67436C69656E7452656374297D29297D66756E6374696F6E20422865297B766F696420303D3D3D65262628653D7B7D293B76617220743D652E64656661756C744D6F64';
wwv_flow_api.g_varchar2_table(67) := '6966696572732C6E3D766F696420303D3D3D743F5B5D3A742C6F3D766F696420303D3D3D28653D652E64656661756C744F7074696F6E73293F463A653B72657475726E2066756E6374696F6E28652C742C69297B66756E6374696F6E206128297B662E66';
wwv_flow_api.g_varchar2_table(68) := '6F7245616368282866756E6374696F6E2865297B72657475726E206528297D29292C663D5B5D7D766F696420303D3D3D69262628693D6F293B76617220733D7B706C6163656D656E743A22626F74746F6D222C6F7264657265644D6F646966696572733A';
wwv_flow_api.g_varchar2_table(69) := '5B5D2C6F7074696F6E733A4F626A6563742E61737369676E287B7D2C462C6F292C6D6F64696669657273446174613A7B7D2C656C656D656E74733A7B7265666572656E63653A652C706F707065723A747D2C617474726962757465733A7B7D2C7374796C';
wwv_flow_api.g_varchar2_table(70) := '65733A7B7D7D2C663D5B5D2C703D21312C633D7B73746174653A732C7365744F7074696F6E733A66756E6374696F6E2869297B72657475726E206128292C732E6F7074696F6E733D4F626A6563742E61737369676E287B7D2C6F2C732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(71) := '2C69292C732E7363726F6C6C506172656E74733D7B7265666572656E63653A722865293F762865293A652E636F6E74657874456C656D656E743F7628652E636F6E74657874456C656D656E74293A5B5D2C706F707065723A762874297D2C693D66756E63';
wwv_flow_api.g_varchar2_table(72) := '74696F6E2865297B76617220743D622865293B72657475726E20492E726564756365282866756E6374696F6E28652C6E297B72657475726E20652E636F6E63617428742E66696C746572282866756E6374696F6E2865297B72657475726E20652E706861';
wwv_flow_api.g_varchar2_table(73) := '73653D3D3D6E7D2929297D292C5B5D297D2866756E6374696F6E2865297B76617220743D652E726564756365282866756E6374696F6E28652C74297B766172206E3D655B742E6E616D655D3B72657475726E20655B742E6E616D655D3D6E3F4F626A6563';
wwv_flow_api.g_varchar2_table(74) := '742E61737369676E287B7D2C6E2C742C7B6F7074696F6E733A4F626A6563742E61737369676E287B7D2C6E2E6F7074696F6E732C742E6F7074696F6E73292C646174613A4F626A6563742E61737369676E287B7D2C6E2E646174612C742E64617461297D';
wwv_flow_api.g_varchar2_table(75) := '293A742C657D292C7B7D293B72657475726E204F626A6563742E6B6579732874292E6D6170282866756E6374696F6E2865297B72657475726E20745B655D7D29297D285B5D2E636F6E636174286E2C732E6F7074696F6E732E6D6F646966696572732929';
wwv_flow_api.g_varchar2_table(76) := '292C732E6F7264657265644D6F646966696572733D692E66696C746572282866756E6374696F6E2865297B72657475726E20652E656E61626C65647D29292C732E6F7264657265644D6F646966696572732E666F7245616368282866756E6374696F6E28';
wwv_flow_api.g_varchar2_table(77) := '65297B76617220743D652E6E616D652C6E3D652E6F7074696F6E733B6E3D766F696420303D3D3D6E3F7B7D3A6E2C2266756E6374696F6E223D3D747970656F6628653D652E65666665637429262628743D65287B73746174653A732C6E616D653A742C69';
wwv_flow_api.g_varchar2_table(78) := '6E7374616E63653A632C6F7074696F6E733A6E7D292C662E7075736828747C7C66756E6374696F6E28297B7D29297D29292C632E75706461746528297D2C666F7263655570646174653A66756E6374696F6E28297B6966282170297B76617220653D732E';
wwv_flow_api.g_varchar2_table(79) := '656C656D656E74732C743D652E7265666572656E63653B6966284128742C653D652E706F707065722929666F7228732E72656374733D7B7265666572656E63653A7528742C792865292C226669786564223D3D3D732E6F7074696F6E732E737472617465';
wwv_flow_api.g_varchar2_table(80) := '6779292C706F707065723A642865297D2C732E72657365743D21312C732E706C6163656D656E743D732E6F7074696F6E732E706C6163656D656E742C732E6F7264657265644D6F646966696572732E666F7245616368282866756E6374696F6E2865297B';
wwv_flow_api.g_varchar2_table(81) := '72657475726E20732E6D6F64696669657273446174615B652E6E616D655D3D4F626A6563742E61737369676E287B7D2C652E64617461297D29292C743D303B743C732E6F7264657265644D6F646966696572732E6C656E6774683B742B2B296966282130';
wwv_flow_api.g_varchar2_table(82) := '3D3D3D732E726573657429732E72657365743D21312C743D2D313B656C73657B766172206E3D732E6F7264657265644D6F646966696572735B745D3B653D6E2E666E3B766172206F3D6E2E6F7074696F6E733B6F3D766F696420303D3D3D6F3F7B7D3A6F';
wwv_flow_api.g_varchar2_table(83) := '2C6E3D6E2E6E616D652C2266756E6374696F6E223D3D747970656F662065262628733D65287B73746174653A732C6F7074696F6E733A6F2C6E616D653A6E2C696E7374616E63653A637D297C7C73297D7D7D2C7570646174653A77282866756E6374696F';
wwv_flow_api.g_varchar2_table(84) := '6E28297B72657475726E206E65772050726F6D697365282866756E6374696F6E2865297B632E666F72636555706461746528292C652873297D29297D29292C64657374726F793A66756E6374696F6E28297B6128292C703D21307D7D3B72657475726E20';
wwv_flow_api.g_varchar2_table(85) := '4128652C74293F28632E7365744F7074696F6E732869292E7468656E282866756E6374696F6E2865297B21702626692E6F6E46697273745570646174652626692E6F6E46697273745570646174652865297D29292C63293A637D7D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(86) := '542865297B76617220742C6F3D652E706F707065722C723D652E706F70706572526563742C693D652E706C6163656D656E742C613D652E6F6666736574732C733D652E706F736974696F6E2C703D652E677075416363656C65726174696F6E2C6C3D652E';
wwv_flow_api.g_varchar2_table(87) := '61646170746976653B69662821303D3D3D28653D652E726F756E644F66667365747329297B653D612E793B76617220753D77696E646F772E646576696365506978656C526174696F7C7C313B653D7B783A7A287A28612E782A75292F75297C7C302C793A';
wwv_flow_api.g_varchar2_table(88) := '7A287A28652A75292F75297C7C307D7D656C736520653D2266756E6374696F6E223D3D747970656F6620653F652861293A613B653D766F696420303D3D3D28653D28753D65292E78293F303A652C753D766F696420303D3D3D28753D752E79293F303A75';
wwv_flow_api.g_varchar2_table(89) := '3B76617220643D612E6861734F776E50726F706572747928227822293B613D612E6861734F776E50726F706572747928227922293B766172206D2C683D226C656674222C763D22746F70222C673D77696E646F773B6966286C297B76617220623D79286F';
wwv_flow_api.g_varchar2_table(90) := '292C773D22636C69656E74486569676874222C783D22636C69656E745769647468223B623D3D3D6E286F292626282273746174696322213D3D6328623D66286F29292E706F736974696F6E262628773D227363726F6C6C486569676874222C783D227363';
wwv_flow_api.g_varchar2_table(91) := '726F6C6C57696474682229292C22746F70223D3D3D69262628763D22626F74746F6D222C752D3D625B775D2D722E6865696768742C752A3D703F313A2D31292C226C656674223D3D3D69262628683D227269676874222C652D3D625B785D2D722E776964';
wwv_flow_api.g_varchar2_table(92) := '74682C652A3D703F313A2D31297D72657475726E206F3D4F626A6563742E61737369676E287B706F736974696F6E3A737D2C6C26264A292C703F4F626A6563742E61737369676E287B7D2C6F2C28286D3D7B7D295B765D3D613F2230223A22222C6D5B68';
wwv_flow_api.g_varchar2_table(93) := '5D3D643F2230223A22222C6D2E7472616E73666F726D3D323E28672E646576696365506978656C526174696F7C7C31293F227472616E736C61746528222B652B2270782C20222B752B22707829223A227472616E736C617465336428222B652B2270782C';
wwv_flow_api.g_varchar2_table(94) := '20222B752B2270782C203029222C6D29293A4F626A6563742E61737369676E287B7D2C6F2C2828743D7B7D295B765D3D613F752B227078223A22222C745B685D3D643F652B227078223A22222C742E7472616E73666F726D3D22222C7429297D66756E63';
wwv_flow_api.g_varchar2_table(95) := '74696F6E20482865297B72657475726E20652E7265706C616365282F6C6566747C72696768747C626F74746F6D7C746F702F672C2866756E6374696F6E2865297B72657475726E20245B655D7D29297D66756E6374696F6E20522865297B72657475726E';
wwv_flow_api.g_varchar2_table(96) := '20652E7265706C616365282F73746172747C656E642F672C2866756E6374696F6E2865297B72657475726E2065655B655D7D29297D66756E6374696F6E205328652C742C6E297B72657475726E20766F696420303D3D3D6E2626286E3D7B783A302C793A';
wwv_flow_api.g_varchar2_table(97) := '307D292C7B746F703A652E746F702D742E6865696768742D6E2E792C72696768743A652E72696768742D742E77696474682B6E2E782C626F74746F6D3A652E626F74746F6D2D742E6865696768742B6E2E792C6C6566743A652E6C6566742D742E776964';
wwv_flow_api.g_varchar2_table(98) := '74682D6E2E787D7D66756E6374696F6E20712865297B72657475726E5B22746F70222C227269676874222C22626F74746F6D222C226C656674225D2E736F6D65282866756E6374696F6E2874297B72657475726E20303C3D655B745D7D29297D76617220';
wwv_flow_api.g_varchar2_table(99) := '433D5B22746F70222C22626F74746F6D222C227269676874222C226C656674225D2C4E3D432E726564756365282866756E6374696F6E28652C74297B72657475726E20652E636F6E636174285B742B222D7374617274222C742B222D656E64225D297D29';
wwv_flow_api.g_varchar2_table(100) := '2C5B5D292C563D5B5D2E636F6E63617428432C5B226175746F225D292E726564756365282866756E6374696F6E28652C74297B72657475726E20652E636F6E636174285B742C742B222D7374617274222C742B222D656E64225D297D292C5B5D292C493D';
wwv_flow_api.g_varchar2_table(101) := '226265666F726552656164207265616420616674657252656164206265666F72654D61696E206D61696E2061667465724D61696E206265666F726557726974652077726974652061667465725772697465222E73706C697428222022292C5F3D4D617468';
wwv_flow_api.g_varchar2_table(102) := '2E6D61782C553D4D6174682E6D696E2C7A3D4D6174682E726F756E642C463D7B706C6163656D656E743A22626F74746F6D222C6D6F646966696572733A5B5D2C73747261746567793A226162736F6C757465227D2C583D7B706173736976653A21307D2C';
wwv_flow_api.g_varchar2_table(103) := '593D7B6E616D653A226576656E744C697374656E657273222C656E61626C65643A21302C70686173653A227772697465222C666E3A66756E6374696F6E28297B7D2C6566666563743A66756E6374696F6E2865297B76617220743D652E73746174652C6F';
wwv_flow_api.g_varchar2_table(104) := '3D652E696E7374616E63652C723D28653D652E6F7074696F6E73292E7363726F6C6C2C693D766F696420303D3D3D727C7C722C613D766F696420303D3D3D28653D652E726573697A65297C7C652C733D6E28742E656C656D656E74732E706F7070657229';
wwv_flow_api.g_varchar2_table(105) := '2C663D5B5D2E636F6E63617428742E7363726F6C6C506172656E74732E7265666572656E63652C742E7363726F6C6C506172656E74732E706F70706572293B72657475726E20692626662E666F7245616368282866756E6374696F6E2865297B652E6164';
wwv_flow_api.g_varchar2_table(106) := '644576656E744C697374656E657228227363726F6C6C222C6F2E7570646174652C58297D29292C612626732E6164644576656E744C697374656E65722822726573697A65222C6F2E7570646174652C58292C66756E6374696F6E28297B692626662E666F';
wwv_flow_api.g_varchar2_table(107) := '7245616368282866756E6374696F6E2865297B652E72656D6F76654576656E744C697374656E657228227363726F6C6C222C6F2E7570646174652C58297D29292C612626732E72656D6F76654576656E744C697374656E65722822726573697A65222C6F';
wwv_flow_api.g_varchar2_table(108) := '2E7570646174652C58297D7D2C646174613A7B7D7D2C473D7B6E616D653A22706F707065724F666673657473222C656E61626C65643A21302C70686173653A2272656164222C666E3A66756E6374696F6E2865297B76617220743D652E73746174653B74';
wwv_flow_api.g_varchar2_table(109) := '2E6D6F64696669657273446174615B652E6E616D655D3D50287B7265666572656E63653A742E72656374732E7265666572656E63652C656C656D656E743A742E72656374732E706F707065722C73747261746567793A226162736F6C757465222C706C61';
wwv_flow_api.g_varchar2_table(110) := '63656D656E743A742E706C6163656D656E747D297D2C646174613A7B7D7D2C4A3D7B746F703A226175746F222C72696768743A226175746F222C626F74746F6D3A226175746F222C6C6566743A226175746F227D2C4B3D7B6E616D653A22636F6D707574';
wwv_flow_api.g_varchar2_table(111) := '655374796C6573222C656E61626C65643A21302C70686173653A226265666F72655772697465222C666E3A66756E6374696F6E2865297B76617220743D652E73746174652C6E3D652E6F7074696F6E733B653D766F696420303D3D3D28653D6E2E677075';
wwv_flow_api.g_varchar2_table(112) := '416363656C65726174696F6E297C7C653B766172206F3D6E2E61646170746976653B6F3D766F696420303D3D3D6F7C7C6F2C6E3D766F696420303D3D3D286E3D6E2E726F756E644F666673657473297C7C6E2C653D7B706C6163656D656E743A7828742E';
wwv_flow_api.g_varchar2_table(113) := '706C6163656D656E74292C706F707065723A742E656C656D656E74732E706F707065722C706F70706572526563743A742E72656374732E706F707065722C677075416363656C65726174696F6E3A657D2C6E756C6C213D742E6D6F646966696572734461';
wwv_flow_api.g_varchar2_table(114) := '74612E706F707065724F666673657473262628742E7374796C65732E706F707065723D4F626A6563742E61737369676E287B7D2C742E7374796C65732E706F707065722C54284F626A6563742E61737369676E287B7D2C652C7B6F6666736574733A742E';
wwv_flow_api.g_varchar2_table(115) := '6D6F64696669657273446174612E706F707065724F6666736574732C706F736974696F6E3A742E6F7074696F6E732E73747261746567792C61646170746976653A6F2C726F756E644F6666736574733A6E7D292929292C6E756C6C213D742E6D6F646966';
wwv_flow_api.g_varchar2_table(116) := '69657273446174612E6172726F77262628742E7374796C65732E6172726F773D4F626A6563742E61737369676E287B7D2C742E7374796C65732E6172726F772C54284F626A6563742E61737369676E287B7D2C652C7B6F6666736574733A742E6D6F6469';
wwv_flow_api.g_varchar2_table(117) := '6669657273446174612E6172726F772C706F736974696F6E3A226162736F6C757465222C61646170746976653A21312C726F756E644F6666736574733A6E7D292929292C742E617474726962757465732E706F707065723D4F626A6563742E6173736967';
wwv_flow_api.g_varchar2_table(118) := '6E287B7D2C742E617474726962757465732E706F707065722C7B22646174612D706F707065722D706C6163656D656E74223A742E706C6163656D656E747D297D2C646174613A7B7D7D2C513D7B6E616D653A226170706C795374796C6573222C656E6162';
wwv_flow_api.g_varchar2_table(119) := '6C65643A21302C70686173653A227772697465222C666E3A66756E6374696F6E2865297B76617220743D652E73746174653B4F626A6563742E6B65797328742E656C656D656E7473292E666F7245616368282866756E6374696F6E2865297B766172206E';
wwv_flow_api.g_varchar2_table(120) := '3D742E7374796C65735B655D7C7C7B7D2C6F3D742E617474726962757465735B655D7C7C7B7D2C723D742E656C656D656E74735B655D3B692872292626732872292626284F626A6563742E61737369676E28722E7374796C652C6E292C4F626A6563742E';
wwv_flow_api.g_varchar2_table(121) := '6B657973286F292E666F7245616368282866756E6374696F6E2865297B76617220743D6F5B655D3B21313D3D3D743F722E72656D6F76654174747269627574652865293A722E73657441747472696275746528652C21303D3D3D743F22223A74297D2929';
wwv_flow_api.g_varchar2_table(122) := '297D29297D2C6566666563743A66756E6374696F6E2865297B76617220743D652E73746174652C6E3D7B706F707065723A7B706F736974696F6E3A742E6F7074696F6E732E73747261746567792C6C6566743A2230222C746F703A2230222C6D61726769';
wwv_flow_api.g_varchar2_table(123) := '6E3A2230227D2C6172726F773A7B706F736974696F6E3A226162736F6C757465227D2C7265666572656E63653A7B7D7D3B72657475726E204F626A6563742E61737369676E28742E656C656D656E74732E706F707065722E7374796C652C6E2E706F7070';
wwv_flow_api.g_varchar2_table(124) := '6572292C742E7374796C65733D6E2C742E656C656D656E74732E6172726F7726264F626A6563742E61737369676E28742E656C656D656E74732E6172726F772E7374796C652C6E2E6172726F77292C66756E6374696F6E28297B4F626A6563742E6B6579';

wwv_flow_api.g_varchar2_table(125) := '7328742E656C656D656E7473292E666F7245616368282866756E6374696F6E2865297B766172206F3D742E656C656D656E74735B655D2C723D742E617474726962757465735B655D7C7C7B7D3B653D4F626A6563742E6B65797328742E7374796C65732E';
wwv_flow_api.g_varchar2_table(126) := '6861734F776E50726F70657274792865293F742E7374796C65735B655D3A6E5B655D292E726564756365282866756E6374696F6E28652C74297B72657475726E20655B745D3D22222C657D292C7B7D292C69286F29262673286F292626284F626A656374';
wwv_flow_api.g_varchar2_table(127) := '2E61737369676E286F2E7374796C652C65292C4F626A6563742E6B6579732872292E666F7245616368282866756E6374696F6E2865297B6F2E72656D6F76654174747269627574652865297D2929297D29297D7D2C72657175697265733A5B22636F6D70';
wwv_flow_api.g_varchar2_table(128) := '7574655374796C6573225D7D2C5A3D7B6E616D653A226F6666736574222C656E61626C65643A21302C70686173653A226D61696E222C72657175697265733A5B22706F707065724F666673657473225D2C666E3A66756E6374696F6E2865297B76617220';
wwv_flow_api.g_varchar2_table(129) := '743D652E73746174652C6E3D652E6E616D652C6F3D766F696420303D3D3D28653D652E6F7074696F6E732E6F6666736574293F5B302C305D3A652C723D28653D562E726564756365282866756E6374696F6E28652C6E297B76617220723D742E72656374';
wwv_flow_api.g_varchar2_table(130) := '732C693D78286E292C613D303C3D5B226C656674222C22746F70225D2E696E6465784F662869293F2D313A312C733D2266756E6374696F6E223D3D747970656F66206F3F6F284F626A6563742E61737369676E287B7D2C722C7B706C6163656D656E743A';
wwv_flow_api.g_varchar2_table(131) := '6E7D29293A6F3B72657475726E20723D28723D735B305D297C7C302C733D2828733D735B315D297C7C30292A612C693D303C3D5B226C656674222C227269676874225D2E696E6465784F662869293F7B783A732C793A727D3A7B783A722C793A737D2C65';
wwv_flow_api.g_varchar2_table(132) := '5B6E5D3D692C657D292C7B7D29295B742E706C6163656D656E745D2C693D722E783B723D722E792C6E756C6C213D742E6D6F64696669657273446174612E706F707065724F666673657473262628742E6D6F64696669657273446174612E706F70706572';
wwv_flow_api.g_varchar2_table(133) := '4F6666736574732E782B3D692C742E6D6F64696669657273446174612E706F707065724F6666736574732E792B3D72292C742E6D6F64696669657273446174615B6E5D3D657D7D2C243D7B6C6566743A227269676874222C72696768743A226C65667422';
wwv_flow_api.g_varchar2_table(134) := '2C626F74746F6D3A22746F70222C746F703A22626F74746F6D227D2C65653D7B73746172743A22656E64222C656E643A227374617274227D2C74653D7B6E616D653A22666C6970222C656E61626C65643A21302C70686173653A226D61696E222C666E3A';
wwv_flow_api.g_varchar2_table(135) := '66756E6374696F6E2865297B76617220743D652E73746174652C6E3D652E6F7074696F6E733B696628653D652E6E616D652C21742E6D6F64696669657273446174615B655D2E5F736B6970297B766172206F3D6E2E6D61696E417869733B6F3D766F6964';
wwv_flow_api.g_varchar2_table(136) := '20303D3D3D6F7C7C6F3B76617220723D6E2E616C74417869733B723D766F696420303D3D3D727C7C723B76617220693D6E2E66616C6C6261636B506C6163656D656E74732C613D6E2E70616464696E672C733D6E2E626F756E646172792C663D6E2E726F';
wwv_flow_api.g_varchar2_table(137) := '6F74426F756E646172792C703D6E2E616C74426F756E646172792C633D6E2E666C6970566172696174696F6E732C6C3D766F696420303D3D3D637C7C632C753D6E2E616C6C6F7765644175746F506C6163656D656E74733B633D78286E3D742E6F707469';
wwv_flow_api.g_varchar2_table(138) := '6F6E732E706C6163656D656E74292C693D697C7C2863213D3D6E26266C3F66756E6374696F6E2865297B696628226175746F223D3D3D782865292972657475726E5B5D3B76617220743D482865293B72657475726E5B522865292C742C522874295D7D28';
wwv_flow_api.g_varchar2_table(139) := '6E293A5B48286E295D293B76617220643D5B6E5D2E636F6E6361742869292E726564756365282866756E6374696F6E28652C6E297B72657475726E20652E636F6E63617428226175746F223D3D3D78286E293F66756E6374696F6E28652C74297B766F69';
wwv_flow_api.g_varchar2_table(140) := '6420303D3D3D74262628743D7B7D293B766172206E3D742E626F756E646172792C6F3D742E726F6F74426F756E646172792C723D742E70616464696E672C693D742E666C6970566172696174696F6E732C613D742E616C6C6F7765644175746F506C6163';
wwv_flow_api.g_varchar2_table(141) := '656D656E74732C733D766F696420303D3D3D613F563A612C663D742E706C6163656D656E742E73706C697428222D22295B315D3B303D3D3D28693D28743D663F693F4E3A4E2E66696C746572282866756E6374696F6E2865297B72657475726E20652E73';
wwv_flow_api.g_varchar2_table(142) := '706C697428222D22295B315D3D3D3D667D29293A43292E66696C746572282866756E6374696F6E2865297B72657475726E20303C3D732E696E6465784F662865297D2929292E6C656E677468262628693D74293B76617220703D692E7265647563652828';
wwv_flow_api.g_varchar2_table(143) := '66756E6374696F6E28742C69297B72657475726E20745B695D3D5728652C7B706C6163656D656E743A692C626F756E646172793A6E2C726F6F74426F756E646172793A6F2C70616464696E673A727D295B782869295D2C747D292C7B7D293B7265747572';
wwv_flow_api.g_varchar2_table(144) := '6E204F626A6563742E6B6579732870292E736F7274282866756E6374696F6E28652C74297B72657475726E20705B655D2D705B745D7D29297D28742C7B706C6163656D656E743A6E2C626F756E646172793A732C726F6F74426F756E646172793A662C70';
wwv_flow_api.g_varchar2_table(145) := '616464696E673A612C666C6970566172696174696F6E733A6C2C616C6C6F7765644175746F506C6163656D656E74733A757D293A6E297D292C5B5D293B6E3D742E72656374732E7265666572656E63652C693D742E72656374732E706F707065723B7661';
wwv_flow_api.g_varchar2_table(146) := '72206D3D6E6577204D61703B633D21303B666F722876617220683D645B305D2C763D303B763C642E6C656E6774683B762B2B297B76617220673D645B765D2C793D782867292C623D227374617274223D3D3D672E73706C697428222D22295B315D2C773D';
wwv_flow_api.g_varchar2_table(147) := '303C3D5B22746F70222C22626F74746F6D225D2E696E6465784F662879292C4F3D773F227769647468223A22686569676874222C6A3D5728742C7B706C6163656D656E743A672C626F756E646172793A732C726F6F74426F756E646172793A662C616C74';
wwv_flow_api.g_varchar2_table(148) := '426F756E646172793A702C70616464696E673A617D293B696628623D773F623F227269676874223A226C656674223A623F22626F74746F6D223A22746F70222C6E5B4F5D3E695B4F5D262628623D48286229292C4F3D482862292C773D5B5D2C6F262677';
wwv_flow_api.g_varchar2_table(149) := '2E7075736828303E3D6A5B795D292C722626772E7075736828303E3D6A5B625D2C303E3D6A5B4F5D292C772E6576657279282866756E6374696F6E2865297B72657475726E20657D2929297B683D672C633D21313B627265616B7D6D2E73657428672C77';
wwv_flow_api.g_varchar2_table(150) := '297D6966286329666F72286F3D66756E6374696F6E2865297B76617220743D642E66696E64282866756E6374696F6E2874297B696628743D6D2E6765742874292972657475726E20742E736C69636528302C65292E6576657279282866756E6374696F6E';
wwv_flow_api.g_varchar2_table(151) := '2865297B72657475726E20657D29297D29293B696628742972657475726E20683D742C22627265616B227D2C723D6C3F333A313B303C72262622627265616B22213D3D6F2872293B722D2D293B742E706C6163656D656E74213D3D68262628742E6D6F64';
wwv_flow_api.g_varchar2_table(152) := '696669657273446174615B655D2E5F736B69703D21302C742E706C6163656D656E743D682C742E72657365743D2130297D7D2C726571756972657349664578697374733A5B226F6666736574225D2C646174613A7B5F736B69703A21317D7D2C6E653D7B';
wwv_flow_api.g_varchar2_table(153) := '6E616D653A2270726576656E744F766572666C6F77222C656E61626C65643A21302C70686173653A226D61696E222C666E3A66756E6374696F6E2865297B76617220743D652E73746174652C6E3D652E6F7074696F6E733B653D652E6E616D653B766172';
wwv_flow_api.g_varchar2_table(154) := '206F3D6E2E6D61696E417869732C723D766F696420303D3D3D6F7C7C6F2C693D766F69642030213D3D286F3D6E2E616C74417869732926266F3B6F3D766F696420303D3D3D286F3D6E2E746574686572297C7C6F3B76617220613D6E2E7465746865724F';
wwv_flow_api.g_varchar2_table(155) := '66667365742C733D766F696420303D3D3D613F303A612C663D5728742C7B626F756E646172793A6E2E626F756E646172792C726F6F74426F756E646172793A6E2E726F6F74426F756E646172792C70616464696E673A6E2E70616464696E672C616C7442';
wwv_flow_api.g_varchar2_table(156) := '6F756E646172793A6E2E616C74426F756E646172797D293B6E3D7828742E706C6163656D656E74293B76617220703D742E706C6163656D656E742E73706C697428222D22295B315D2C633D21702C6C3D4C286E293B6E3D2278223D3D3D6C3F2279223A22';
wwv_flow_api.g_varchar2_table(157) := '78222C613D742E6D6F64696669657273446174612E706F707065724F6666736574733B76617220753D742E72656374732E7265666572656E63652C6D3D742E72656374732E706F707065722C683D2266756E6374696F6E223D3D747970656F6620733F73';
wwv_flow_api.g_varchar2_table(158) := '284F626A6563742E61737369676E287B7D2C742E72656374732C7B706C6163656D656E743A742E706C6163656D656E747D29293A733B696628733D7B783A302C793A307D2C61297B696628727C7C69297B76617220763D2279223D3D3D6C3F22746F7022';
wwv_flow_api.g_varchar2_table(159) := '3A226C656674222C673D2279223D3D3D6C3F22626F74746F6D223A227269676874222C623D2279223D3D3D6C3F22686569676874223A227769647468222C773D615B6C5D2C4F3D615B6C5D2B665B765D2C6A3D615B6C5D2D665B675D2C453D6F3F2D6D5B';
wwv_flow_api.g_varchar2_table(160) := '625D2F323A302C443D227374617274223D3D3D703F755B625D3A6D5B625D3B703D227374617274223D3D3D703F2D6D5B625D3A2D755B625D2C6D3D742E656C656D656E74732E6172726F772C6D3D6F26266D3F64286D293A7B77696474683A302C686569';
wwv_flow_api.g_varchar2_table(161) := '6768743A307D3B76617220503D742E6D6F64696669657273446174615B226172726F772370657273697374656E74225D3F742E6D6F64696669657273446174615B226172726F772370657273697374656E74225D2E70616464696E673A7B746F703A302C';
wwv_flow_api.g_varchar2_table(162) := '72696768743A302C626F74746F6D3A302C6C6566743A307D3B763D505B765D2C673D505B675D2C6D3D5F28302C5528755B625D2C6D5B625D29292C443D633F755B625D2F322D452D6D2D762D683A442D6D2D762D682C753D633F2D755B625D2F322B452B';
wwv_flow_api.g_varchar2_table(163) := '6D2B672B683A702B6D2B672B682C633D742E656C656D656E74732E6172726F7726267928742E656C656D656E74732E6172726F77292C683D742E6D6F64696669657273446174612E6F66667365743F742E6D6F64696669657273446174612E6F66667365';
wwv_flow_api.g_varchar2_table(164) := '745B742E706C6163656D656E745D5B6C5D3A302C633D615B6C5D2B442D682D28633F2279223D3D3D6C3F632E636C69656E74546F707C7C303A632E636C69656E744C6566747C7C303A30292C753D615B6C5D2B752D682C72262628723D6F3F55284F2C63';
wwv_flow_api.g_varchar2_table(165) := '293A4F2C6A3D6F3F5F286A2C75293A6A2C723D5F28722C5528772C6A29292C615B6C5D3D722C735B6C5D3D722D77292C69262628723D28693D615B6E5D292B665B2278223D3D3D6C3F22746F70223A226C656674225D2C663D692D665B2278223D3D3D6C';
wwv_flow_api.g_varchar2_table(166) := '3F22626F74746F6D223A227269676874225D2C723D6F3F5528722C63293A722C6F3D6F3F5F28662C75293A662C6F3D5F28722C5528692C6F29292C615B6E5D3D6F2C735B6E5D3D6F2D69297D742E6D6F64696669657273446174615B655D3D737D7D2C72';
wwv_flow_api.g_varchar2_table(167) := '6571756972657349664578697374733A5B226F6666736574225D7D2C6F653D7B6E616D653A226172726F77222C656E61626C65643A21302C70686173653A226D61696E222C666E3A66756E6374696F6E2865297B76617220742C6E3D652E73746174652C';
wwv_flow_api.g_varchar2_table(168) := '6F3D652E6E616D652C723D652E6F7074696F6E732C693D6E2E656C656D656E74732E6172726F772C613D6E2E6D6F64696669657273446174612E706F707065724F6666736574732C733D78286E2E706C6163656D656E74293B696628653D4C2873292C73';
wwv_flow_api.g_varchar2_table(169) := '3D303C3D5B226C656674222C227269676874225D2E696E6465784F662873293F22686569676874223A227769647468222C69262661297B723D4D28226E756D62657222213D747970656F6628723D2266756E6374696F6E223D3D747970656F6628723D72';
wwv_flow_api.g_varchar2_table(170) := '2E70616464696E67293F72284F626A6563742E61737369676E287B7D2C6E2E72656374732C7B706C6163656D656E743A6E2E706C6163656D656E747D29293A72293F723A6B28722C4329293B76617220663D642869292C703D2279223D3D3D653F22746F';
wwv_flow_api.g_varchar2_table(171) := '70223A226C656674222C633D2279223D3D3D653F22626F74746F6D223A227269676874222C6C3D6E2E72656374732E7265666572656E63655B735D2B6E2E72656374732E7265666572656E63655B655D2D615B655D2D6E2E72656374732E706F70706572';
wwv_flow_api.g_varchar2_table(172) := '5B735D3B613D615B655D2D6E2E72656374732E7265666572656E63655B655D2C613D28693D28693D79286929293F2279223D3D3D653F692E636C69656E744865696768747C7C303A692E636C69656E7457696474687C7C303A30292F322D665B735D2F32';
wwv_flow_api.g_varchar2_table(173) := '2B286C2F322D612F32292C733D5F28725B705D2C5528612C692D665B735D2D725B635D29292C6E2E6D6F64696669657273446174615B6F5D3D2828743D7B7D295B655D3D732C742E63656E7465724F66667365743D732D612C74297D7D2C656666656374';
wwv_flow_api.g_varchar2_table(174) := '3A66756E6374696F6E2865297B76617220743D652E73746174653B6966286E756C6C213D28653D766F696420303D3D3D28653D652E6F7074696F6E732E656C656D656E74293F225B646174612D706F707065722D6172726F775D223A6529297B69662822';
wwv_flow_api.g_varchar2_table(175) := '737472696E67223D3D747970656F66206526262128653D742E656C656D656E74732E706F707065722E717565727953656C6563746F72286529292972657475726E3B4F28742E656C656D656E74732E706F707065722C6529262628742E656C656D656E74';
wwv_flow_api.g_varchar2_table(176) := '732E6172726F773D65297D7D2C72657175697265733A5B22706F707065724F666673657473225D2C726571756972657349664578697374733A5B2270726576656E744F766572666C6F77225D7D2C72653D7B6E616D653A2268696465222C656E61626C65';
wwv_flow_api.g_varchar2_table(177) := '643A21302C70686173653A226D61696E222C726571756972657349664578697374733A5B2270726576656E744F766572666C6F77225D2C666E3A66756E6374696F6E2865297B76617220743D652E73746174653B653D652E6E616D653B766172206E3D74';
wwv_flow_api.g_varchar2_table(178) := '2E72656374732E7265666572656E63652C6F3D742E72656374732E706F707065722C723D742E6D6F64696669657273446174612E70726576656E744F766572666C6F772C693D5728742C7B656C656D656E74436F6E746578743A227265666572656E6365';
wwv_flow_api.g_varchar2_table(179) := '227D292C613D5728742C7B616C74426F756E646172793A21307D293B6E3D5328692C6E292C6F3D5328612C6F2C72292C723D71286E292C613D71286F292C742E6D6F64696669657273446174615B655D3D7B7265666572656E6365436C697070696E674F';
wwv_flow_api.g_varchar2_table(180) := '6666736574733A6E2C706F707065724573636170654F6666736574733A6F2C69735265666572656E636548696464656E3A722C686173506F70706572457363617065643A617D2C742E617474726962757465732E706F707065723D4F626A6563742E6173';
wwv_flow_api.g_varchar2_table(181) := '7369676E287B7D2C742E617474726962757465732E706F707065722C7B22646174612D706F707065722D7265666572656E63652D68696464656E223A722C22646174612D706F707065722D65736361706564223A617D297D7D2C69653D42287B64656661';
wwv_flow_api.g_varchar2_table(182) := '756C744D6F646966696572733A5B592C472C4B2C515D7D292C61653D5B592C472C4B2C512C5A2C74652C6E652C6F652C72655D2C73653D42287B64656661756C744D6F646966696572733A61657D293B652E6170706C795374796C65733D512C652E6172';
wwv_flow_api.g_varchar2_table(183) := '726F773D6F652C652E636F6D707574655374796C65733D4B2C652E637265617465506F707065723D73652C652E637265617465506F707065724C6974653D69652C652E64656661756C744D6F646966696572733D61652C652E6465746563744F76657266';
wwv_flow_api.g_varchar2_table(184) := '6C6F773D572C652E6576656E744C697374656E6572733D592C652E666C69703D74652C652E686964653D72652C652E6F66667365743D5A2C652E706F7070657247656E657261746F723D422C652E706F707065724F6666736574733D472C652E70726576';
wwv_flow_api.g_varchar2_table(185) := '656E744F766572666C6F773D6E652C4F626A6563742E646566696E6550726F706572747928652C225F5F65734D6F64756C65222C7B76616C75653A21307D297D29293B0A2F2F2320736F757263654D617070696E6755524C3D706F707065722E6D696E2E';
wwv_flow_api.g_varchar2_table(186) := '6A732E6D61700A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215321395926053070)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'libraries/popper/popper.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D746F705D7B7472616E73666F726D2D6F726967696E3A626F74746F6D7D2E74697070792D626F785B646174612D';
wwv_flow_api.g_varchar2_table(2) := '616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D746F705D5B646174612D73746174653D76697369626C655D7B7472616E73666F726D3A7065727370656374697665283730307078297D2E74697070792D';
wwv_flow_api.g_varchar2_table(3) := '626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D746F705D5B646174612D73746174653D68696464656E5D7B7472616E73666F726D3A706572737065637469766528373030707829';
wwv_flow_api.g_varchar2_table(4) := '207472616E736C61746559283870782920726F7461746558283630646567297D2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D626F74746F6D5D7B7472616E73';
wwv_flow_api.g_varchar2_table(5) := '666F726D2D6F726967696E3A746F707D2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D626F74746F6D5D5B646174612D73746174653D76697369626C655D7B74';
wwv_flow_api.g_varchar2_table(6) := '72616E73666F726D3A7065727370656374697665283730307078297D2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D626F74746F6D5D5B646174612D73746174';
wwv_flow_api.g_varchar2_table(7) := '653D68696464656E5D7B7472616E73666F726D3A706572737065637469766528373030707829207472616E736C61746559282D3870782920726F7461746558282D3630646567297D2E74697070792D626F785B646174612D616E696D6174696F6E3D7065';
wwv_flow_api.g_varchar2_table(8) := '7273706563746976655D5B646174612D706C6163656D656E745E3D6C6566745D7B7472616E73666F726D2D6F726967696E3A72696768747D2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D';
wwv_flow_api.g_varchar2_table(9) := '706C6163656D656E745E3D6C6566745D5B646174612D73746174653D76697369626C655D7B7472616E73666F726D3A7065727370656374697665283730307078297D2E74697070792D626F785B646174612D616E696D6174696F6E3D7065727370656374';
wwv_flow_api.g_varchar2_table(10) := '6976655D5B646174612D706C6163656D656E745E3D6C6566745D5B646174612D73746174653D68696464656E5D7B7472616E73666F726D3A706572737065637469766528373030707829207472616E736C61746558283870782920726F7461746559282D';
wwv_flow_api.g_varchar2_table(11) := '3630646567297D2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D72696768745D7B7472616E73666F726D2D6F726967696E3A6C6566747D2E74697070792D626F';
wwv_flow_api.g_varchar2_table(12) := '785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D72696768745D5B646174612D73746174653D76697369626C655D7B7472616E73666F726D3A7065727370656374697665283730307078';
wwv_flow_api.g_varchar2_table(13) := '297D2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D706C6163656D656E745E3D72696768745D5B646174612D73746174653D68696464656E5D7B7472616E73666F726D3A70657273706563';
wwv_flow_api.g_varchar2_table(14) := '7469766528373030707829207472616E736C61746558282D3870782920726F7461746559283630646567297D2E74697070792D626F785B646174612D616E696D6174696F6E3D70657273706563746976655D5B646174612D73746174653D68696464656E';
wwv_flow_api.g_varchar2_table(15) := '5D7B6F7061636974793A307D0A2F2A2320736F757263654D617070696E6755524C3D70657273706563746976652E6373732E6D61702A2F';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215323033094084824)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/perspective.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C22736F7572636573223A5B2270657273706563746976652E637373225D2C226E616D6573223A5B5D2C226D617070696E6773223A22414141412C32442C434143452C75422C434145442C2B452C434143432C34422C4341';
wwv_flow_api.g_varchar2_table(2) := '45442C38452C434143432C32442C434145442C38442C434143432C6F422C434145442C6B462C434143432C34422C434145442C69462C434143432C36442C434145442C34442C434143432C73422C434145442C67462C434143432C34422C434145442C2B';
wwv_flow_api.g_varchar2_table(3) := '452C434143432C34442C434145442C36442C434143432C71422C434145442C69462C434143432C34422C434145442C67462C434143432C34442C434145442C79442C434143432C53222C2266696C65223A2270657273706563746976652E637373222C22';
wwv_flow_api.g_varchar2_table(4) := '736F7572636573436F6E74656E74223A5B222E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C22746F705C225D207B5C6E5C74207472616E73666F726D2D';
wwv_flow_api.g_varchar2_table(5) := '6F726967696E3A20626F74746F6D3B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C22746F705C225D5B646174612D73746174653D2776';
wwv_flow_api.g_varchar2_table(6) := '697369626C65275D207B5C6E5C74207472616E73666F726D3A207065727370656374697665283730307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C61';
wwv_flow_api.g_varchar2_table(7) := '63656D656E745E3D5C22746F705C225D5B646174612D73746174653D2768696464656E275D207B5C6E5C74207472616E73666F726D3A20706572737065637469766528373030707829207472616E736C61746559283870782920726F7461746558283630';
wwv_flow_api.g_varchar2_table(8) := '646567293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C22626F74746F6D5C225D207B5C6E5C74207472616E73666F726D2D6F726967';
wwv_flow_api.g_varchar2_table(9) := '696E3A20746F703B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C22626F74746F6D5C225D5B646174612D73746174653D277669736962';
wwv_flow_api.g_varchar2_table(10) := '6C65275D207B5C6E5C74207472616E73666F726D3A207065727370656374697665283730307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D65';
wwv_flow_api.g_varchar2_table(11) := '6E745E3D5C22626F74746F6D5C225D5B646174612D73746174653D2768696464656E275D207B5C6E5C74207472616E73666F726D3A20706572737065637469766528373030707829207472616E736C61746559282D3870782920726F7461746558282D36';
wwv_flow_api.g_varchar2_table(12) := '30646567293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C226C6566745C225D207B5C6E5C74207472616E73666F726D2D6F72696769';
wwv_flow_api.g_varchar2_table(13) := '6E3A2072696768743B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C226C6566745C225D5B646174612D73746174653D2776697369626C';
wwv_flow_api.g_varchar2_table(14) := '65275D207B5C6E5C74207472616E73666F726D3A207065727370656374697665283730307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E';
wwv_flow_api.g_varchar2_table(15) := '745E3D5C226C6566745C225D5B646174612D73746174653D2768696464656E275D207B5C6E5C74207472616E73666F726D3A20706572737065637469766528373030707829207472616E736C61746558283870782920726F7461746559282D3630646567';
wwv_flow_api.g_varchar2_table(16) := '293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C2272696768745C225D207B5C6E5C74207472616E73666F726D2D6F726967696E3A20';
wwv_flow_api.g_varchar2_table(17) := '6C6566743B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D5C2272696768745C225D5B646174612D73746174653D2776697369626C65275D';
wwv_flow_api.g_varchar2_table(18) := '207B5C6E5C74207472616E73666F726D3A207065727370656374697665283730307078293B5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D706C6163656D656E745E3D';
wwv_flow_api.g_varchar2_table(19) := '5C2272696768745C225D5B646174612D73746174653D2768696464656E275D207B5C6E5C74207472616E73666F726D3A20706572737065637469766528373030707829207472616E736C61746558282D3870782920726F7461746559283630646567293B';
wwv_flow_api.g_varchar2_table(20) := '5C6E7D5C6E202E74697070792D626F785B646174612D616E696D6174696F6E3D277065727370656374697665275D5B646174612D73746174653D2768696464656E275D207B5C6E5C74206F7061636974793A20303B5C6E7D225D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(215323481875084828)
,p_plugin_id=>wwv_flow_api.id(212503470416800524)
,p_file_name=>'css/perspective.css.map'
,p_mime_type=>'application/json'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done


