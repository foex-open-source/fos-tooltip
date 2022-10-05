/* global apex,$ */

window.FOS = window.FOS || {};
FOS.utils = FOS.utils || {};
FOS.utils.tooltip = FOS.utils.tooltip || {};

/**
*
* @param {object}   	config 	                    	Configuration object containing the plugin settings
* @param {string}   	config.animation               	The value change animation
* @param {string}       config.attrToSubmit             Comma separated list of attribute names (eg. id, data-num, etc..) that used on the server
* @param {string}       config.bgColor                  The background color of the tooltip
* @param {string}       config.txtColor                 The text color of the tooltip
* @param {boolean}      config.cacheResult              Whether store the result in memory or not
* @param {string}       config.content                  The content of the tooltip
* @param {boolean}      config.disableArrow             Add arrows to the tooltip or not
* @param {string}       config.displayOn                The triggering event
* @param {string}       config.trailColor               Color of the progress trail.
* @param {string}       config.duration                 Duration of the animation in ms
* @param {boolean}      config.escapeHTML               Render HTML in the tooltip or not
* @param {boolean}      config.followCursor             The tooltip follows the cursor movement
* @param {number}       config.hideDelay                Hide after x ms
* @param {boolean}      config.interactiveText          Allows interactions with the tooltip
* @param {string}       config.loadingText              The text to be displayed while waiting for the response
* @param {string}       config.noDataFoundText          The text to be displayed if the response does not contain any data
* @param {string}       config.placement                The placement of the tooltip
* @param {number}       config.showDelay                Show after x ms
* @param {number}       config.showOnCreate             Show the tooltip immediately when the plugin has been executed e.g. on page load
* @param {string}       config.itemsToSubmit            Items used in the source query.
* @param {string}       config.theme                    The name of the tooltip's theme
* @param {string}       config.src                      The type of the source [static|dynamic]
* @param {string}       config.staticSrc                The static text content of the tooltip
* @param {function}  	initJs  						Optional Initialization JavaScript Code function
*/

FOS.utils.tooltip.init = function (daContext, config, initFn) {
    const EVT_TOOLTIP_SHOW = 'fos-tooltip-show';
    // get the affected elements
    let affectedElements = daContext.affectedElements.length == 0 ? document.querySelector(daContext.action.affectedElements) : daContext.affectedElements.get();

    // default values
    config.loadingText = config.loadingText || 'Loading...';
    config.noDataFoundText = config.noDataFoundText || 'No data found.';
    config.delay = [300, 0];
    config.duration = parseInt(config.duration, 10);
    config.arrow = !config.disableArrow;
    config.trigger = (config.displayOn == 'hover') ? 'mouseenter' : 'click';
    config.allowHTML = !config.escapeHTML;
    config.interactive = config.interactiveText;
    if (config.interactiveText) {
        config.appendTo = document.body;
    }
    config.content = function (reference) {
        getContent(reference);
    }
    config.onShow = function(instance) {
        getDynamicContent(instance);
        apex.event.trigger(instance.reference, EVT_TOOLTIP_SHOW, config);
    }
    config.onCreate = function (instance) {
        // Setup our own custom state properties
        instance._isFetching = false;
        instance._error = null;

    }
    if (config.src != 'static') {
        config.onHidden = function (instance) {
            setBackToDefault(instance);
        }
    }
    apex.debug.info('FOS - Tooltip', config);

    // Allow the developer to perform any last (centralized) changes using Javascript Initialization Code setting
    if (initFn instanceof Function) {
        debugger;
        initFn.call(daContext, config);
    }

    // Show warning if the necessary Application Items are not available
    if (config.errorMsg) {
        apex.debug.info(config.errorMsg);
    }

    // cache
    const cache = {
        store: new Map(),
        expired: function (expiresAt) {
            return expiresAt && expiresAt < Date.now();
        },
        get: function (key) {
            let { value, expiresAt } = this.store.get(key) || {};
            if (this.expired(expiresAt)) {
                this.store.delete(key);
                return undefined;
            }
            return value;
        },
        set: function (key, value, expiresAt) {
            if (!expiresAt) {
                expiresAt = Date.now() + 1000 * 60 * 60;
            }
            this.store.set(key, { value, expiresAt });
        }
    }
    // initialize the tooltip
    tippy(affectedElements, config);

    function getContent(ref) {
        if (config.src == 'static') {
            return apex.util.applyTemplate(config.staticSrc, {
                defaultEscapeFilter: config.escapeHTML ? 'HTML' : 'RAW'
            });
        } else if (config.src == 'defined-in-attribute') {
            return $(ref).attr(config.attrSrc);
        } else {
            return config.loadingText;
        }
    }

    function getDynamicContent(instance) {
        if (config.src == 'defined-in-attribute' || config.src == 'static') {
            instance.setContent(getContent(instance.reference));
        } else {
            if (config.cacheResult) {
                let cachedValue = cache.get(instance.id);
                if (cachedValue) {
                    instance.setContent(cachedValue);
                    instance._isFetching = false;
                    return;
                }
            }
            getRemoteContent(instance);
            instance._isFetching = false;
            instance._error = null;
        }
        return true;
    }

    function getRemoteContent(instance) {
        let attributesToSubmit = [];
        config.attrToSubmit?.split(',').forEach((attr) => {
            attributesToSubmit.push(instance.reference.getAttribute(attr));
        });

        instance.setContent(config.loadingText);

        let result = apex.server.plugin(config.ajaxId, {
            pageItems: config.itemsToSubmit,
            x01: attributesToSubmit[0],
            x02: attributesToSubmit[1],
            x03: attributesToSubmit[2]
        });
        result.done((data) => {
            if (data.success) {
                instance.setContent(data.src || config.noDataFoundText);
                if (data.src && config.cacheResult) {
                    cache.set(instance.id, data.src);
                }
            } else {
                apex.message.clearErrors();
                apex.message.showErrors({
                    type: 'error',
                    location: 'page',
                    message: 'Tooltip Error: ' + data.errMsg
                });
            }
            instance.setContent(data.success ? data.src : data.errMsg);
        }).fail((jqXHR, textStatus, errorThrown) => {
            instance._error = textStatus;
            instance.setContent(`Request failed. ${textStatus}`);
        }).always(() => {
            instance._isFetching = false;
        })
    }

    function setBackToDefault(instance) {
        instance.setContent(config.loadingText);
        // Unset these properties so new network requests can be initiated
        instance._error = null;
    };
}

