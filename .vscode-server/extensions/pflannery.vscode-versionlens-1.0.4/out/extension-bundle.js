const System = require('systemjs');
exports.activate = async function (context) {
    const root = await System.import('root');
    return root.composition(context);
};
System.register("core/generics/nullable", [], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/generics/collections", [], function (exports_2, context_2) {
    "use strict";
    var __moduleName = context_2 && context_2.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/generics/repositories", [], function (exports_3, context_3) {
    "use strict";
    var __moduleName = context_3 && context_3.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/generics", ["core/generics/nullable", "core/generics/collections", "core/generics/repositories"], function (exports_4, context_4) {
    "use strict";
    var __moduleName = context_4 && context_4.id;
    function exportStar_1(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default") exports[n] = m[n];
        }
        exports_4(exports);
    }
    return {
        setters: [
            function (nullable_1_1) {
                exportStar_1(nullable_1_1);
            },
            function (collections_1_1) {
                exportStar_1(collections_1_1);
            },
            function (repositories_1_1) {
                exportStar_1(repositories_1_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/configuration/vscodeConfig", [], function (exports_5, context_5) {
    "use strict";
    var VsCodeConfig;
    var __moduleName = context_5 && context_5.id;
    return {
        setters: [],
        execute: function () {
            // allows vscode configuration to be defrosted
            // Useful for accessing hot changing values from settings.json
            // Stays frozen until defrost() is called and then refrosts
            VsCodeConfig = class VsCodeConfig {
                constructor(section) {
                    this.section = section;
                    this.frozen = null;
                }
                get repo() {
                    const { workspace } = require('vscode');
                    return workspace.getConfiguration(this.section);
                }
                get(key) {
                    if (this.frozen === null) {
                        this.frozen = this.repo;
                    }
                    return this.frozen.get(key);
                }
                defrost() {
                    this.frozen = null;
                }
            };
            exports_5("VsCodeConfig", VsCodeConfig);
        }
    };
});
System.register("infrastructure/configuration", ["infrastructure/configuration/vscodeConfig"], function (exports_6, context_6) {
    "use strict";
    var __moduleName = context_6 && context_6.id;
    function exportStar_2(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default") exports[n] = m[n];
        }
        exports_6(exports);
    }
    return {
        setters: [
            function (vscodeConfig_1_1) {
                exportStar_2(vscodeConfig_1_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("core/logging/definitions/iLogger", [], function (exports_7, context_7) {
    "use strict";
    var LogLevelTypes;
    var __moduleName = context_7 && context_7.id;
    return {
        setters: [],
        execute: function () {
            (function (LogLevelTypes) {
                LogLevelTypes["Error"] = "error";
                LogLevelTypes["Info"] = "info";
                LogLevelTypes["Verbose"] = "verbose";
                LogLevelTypes["Debug"] = "debug";
            })(LogLevelTypes || (LogLevelTypes = {}));
            exports_7("LogLevelTypes", LogLevelTypes);
        }
    };
});
System.register("core/logging/definitions/iLoggingOptions", [], function (exports_8, context_8) {
    "use strict";
    var __moduleName = context_8 && context_8.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/configuration/definitions/iOptions", [], function (exports_9, context_9) {
    "use strict";
    var __moduleName = context_9 && context_9.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/configuration/options", [], function (exports_10, context_10) {
    "use strict";
    var Options;
    var __moduleName = context_10 && context_10.id;
    return {
        setters: [],
        execute: function () {
            Options = class Options {
                constructor(config, section) {
                    this.config = config;
                    this.section = (section.length > 0) ? section + '.' : '';
                }
                get(key) {
                    return this.config.get(`${this.section}${key}`);
                }
                defrost() {
                    this.config.defrost();
                }
            };
            exports_10("Options", Options);
        }
    };
});
System.register("core/configuration/optionsWithFallback", ["core/configuration"], function (exports_11, context_11) {
    "use strict";
    var configuration_1, OptionsWithFallback;
    var __moduleName = context_11 && context_11.id;
    return {
        setters: [
            function (configuration_1_1) {
                configuration_1 = configuration_1_1;
            }
        ],
        execute: function () {
            OptionsWithFallback = class OptionsWithFallback extends configuration_1.Options {
                constructor(config, section, fallbackSection = null) {
                    super(config, section);
                    this.fallbackSection = fallbackSection;
                }
                get(key) {
                    // attempt to get the section value
                    const sectionValue = this.config.get(`${this.section}${key}`);
                    // return section value
                    if (sectionValue !== null && sectionValue !== undefined)
                        return sectionValue;
                    // attempt to get fallback section value
                    let fallbackSectionValue;
                    if (this.fallbackSection !== null) {
                        fallbackSectionValue = this.config.get(`${this.fallbackSection}.${key}`);
                    }
                    // return fallback key value
                    return fallbackSectionValue;
                }
                getOrDefault(key, defaultValue) {
                    // attempt to get the section value
                    const value = this.get(key);
                    // return key value
                    if (value !== null && value !== undefined)
                        return value;
                    // return default value
                    return defaultValue;
                }
            };
            exports_11("OptionsWithFallback", OptionsWithFallback);
        }
    };
});
System.register("core/configuration", ["core/configuration/definitions/iOptions", "core/configuration/options", "core/configuration/optionsWithFallback"], function (exports_12, context_12) {
    "use strict";
    var __moduleName = context_12 && context_12.id;
    function exportStar_3(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default") exports[n] = m[n];
        }
        exports_12(exports);
    }
    return {
        setters: [
            function (iOptions_1_1) {
                exportStar_3(iOptions_1_1);
            },
            function (options_1_1) {
                exportStar_3(options_1_1);
            },
            function (optionsWithFallback_1_1) {
                exportStar_3(optionsWithFallback_1_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("core/logging/loggingOptions", ["core/configuration"], function (exports_13, context_13) {
    "use strict";
    var configuration_2, LoggingContributions, LoggingOptions;
    var __moduleName = context_13 && context_13.id;
    return {
        setters: [
            function (configuration_2_1) {
                configuration_2 = configuration_2_1;
            }
        ],
        execute: function () {
            (function (LoggingContributions) {
                LoggingContributions["LoggingLevel"] = "level";
            })(LoggingContributions || (LoggingContributions = {}));
            exports_13("LoggingContributions", LoggingContributions);
            LoggingOptions = class LoggingOptions extends configuration_2.Options {
                constructor(config, section) {
                    super(config, section);
                }
                get level() {
                    return super.get(LoggingContributions.LoggingLevel);
                }
                get timestampFormat() { return 'YYYY-MM-DD HH:mm:ss'; }
            };
            exports_13("LoggingOptions", LoggingOptions);
        }
    };
});
System.register("core/logging", ["core/logging/definitions/iLoggingOptions", "core/logging/definitions/iLogger", "core/logging/loggingOptions"], function (exports_14, context_14) {
    "use strict";
    var __moduleName = context_14 && context_14.id;
    function exportStar_4(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default") exports[n] = m[n];
        }
        exports_14(exports);
    }
    return {
        setters: [
            function (iLoggingOptions_1_1) {
                exportStar_4(iLoggingOptions_1_1);
            },
            function (iLogger_1_1) {
                exportStar_4(iLogger_1_1);
            },
            function (loggingOptions_1_1) {
                exportStar_4(loggingOptions_1_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/logging/transports/outputChannelTransport", [], function (exports_15, context_15) {
    "use strict";
    var Transport, MESSAGE, OutputChannelTransport;
    var __moduleName = context_15 && context_15.id;
    function createOutputChannelTransport(channel, transportOptions) {
        return new OutputChannelTransport(channel, transportOptions);
    }
    exports_15("createOutputChannelTransport", createOutputChannelTransport);
    return {
        setters: [],
        execute: function () {
            Transport = require('winston').Transport;
            MESSAGE = Symbol.for('message');
            OutputChannelTransport = class OutputChannelTransport extends Transport {
                constructor(channel, transportOptions) {
                    super(transportOptions);
                    this.channel = channel;
                }
                log(entry, callback) {
                    setImmediate(() => {
                        this.emit('logged', entry);
                        this.channel.appendLine(`${entry[MESSAGE]}`);
                    });
                    callback();
                }
            };
        }
    };
});
System.register("infrastructure/logging/loggerFactory", ["infrastructure/logging/transports/outputChannelTransport"], function (exports_16, context_16) {
    "use strict";
    var outputChannelTransport_1;
    var __moduleName = context_16 && context_16.id;
    function createWinstonLogger(channel, options) {
        const { loggers, format, transports } = require('winston');
        const logTransports = [
            // capture errors in the console
            new transports.Console({ level: 'error' }),
            // send info to output channel
            outputChannelTransport_1.createOutputChannelTransport(channel, { level: options.level })
        ];
        const logFormat = format.combine(format.timestamp({ format: options.timestampFormat }), format.simple(), format.splat(), format.printf(loggerFormatter));
        return loggers.add(channel.name, {
            format: logFormat,
            transports: logTransports,
        });
    }
    exports_16("createWinstonLogger", createWinstonLogger);
    function loggerFormatter(entry) {
        return `${entry.timestamp} ${entry.level} ${entry.namespace}: ${entry.message}`;
    }
    return {
        setters: [
            function (outputChannelTransport_1_1) {
                outputChannelTransport_1 = outputChannelTransport_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/logging", ["infrastructure/logging/loggerFactory"], function (exports_17, context_17) {
    "use strict";
    var __moduleName = context_17 && context_17.id;
    function exportStar_5(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default") exports[n] = m[n];
        }
        exports_17(exports);
    }
    return {
        setters: [
            function (loggerFactory_1_1) {
                exportStar_5(loggerFactory_1_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("core/clients/definitions/clientResponses", [], function (exports_18, context_18) {
    "use strict";
    var ClientResponseSource;
    var __moduleName = context_18 && context_18.id;
    return {
        setters: [],
        execute: function () {
            (function (ClientResponseSource) {
                ClientResponseSource["remote"] = "remote";
                ClientResponseSource["cache"] = "cache";
                ClientResponseSource["local"] = "local";
            })(ClientResponseSource || (ClientResponseSource = {}));
            exports_18("ClientResponseSource", ClientResponseSource);
        }
    };
});
System.register("core/clients/definitions/clientRequests", [], function (exports_19, context_19) {
    "use strict";
    var HttpClientRequestMethods;
    var __moduleName = context_19 && context_19.id;
    return {
        setters: [],
        execute: function () {
            (function (HttpClientRequestMethods) {
                HttpClientRequestMethods["get"] = "GET";
                HttpClientRequestMethods["head"] = "HEAD";
            })(HttpClientRequestMethods || (HttpClientRequestMethods = {}));
            exports_19("HttpClientRequestMethods", HttpClientRequestMethods);
        }
    };
});
System.register("core/clients/definitions/iOptions", [], function (exports_20, context_20) {
    "use strict";
    var CachingContributions, HttpContributions;
    var __moduleName = context_20 && context_20.id;
    return {
        setters: [],
        execute: function () {
            (function (CachingContributions) {
                CachingContributions["CacheDuration"] = "duration";
            })(CachingContributions || (CachingContributions = {}));
            exports_20("CachingContributions", CachingContributions);
            (function (HttpContributions) {
                HttpContributions["StrictSSL"] = "strictSSL";
            })(HttpContributions || (HttpContributions = {}));
            exports_20("HttpContributions", HttpContributions);
        }
    };
});
System.register("core/clients/caching/expiryCacheMap", [], function (exports_21, context_21) {
    "use strict";
    var ExpiryCacheMap;
    var __moduleName = context_21 && context_21.id;
    return {
        setters: [],
        execute: function () {
            ExpiryCacheMap = class ExpiryCacheMap {
                constructor(options) {
                    this.options = options;
                    this.cacheMap = {};
                }
                clear() {
                    this.cacheMap = {};
                }
                hasExpired(key) {
                    const entry = this.cacheMap[key];
                    if (!entry)
                        return true;
                    return Date.now() > entry.expiryTime;
                }
                expire(key) {
                    const entry = this.cacheMap[key];
                    if (entry)
                        delete this.cacheMap[key];
                    return entry.data;
                }
                get(key) {
                    const entry = this.cacheMap[key];
                    return entry && entry.data;
                }
                set(key, data) {
                    const expiryTime = Date.now() + this.options.duration;
                    const newEntry = {
                        expiryTime,
                        data
                    };
                    this.cacheMap[key] = newEntry;
                    return newEntry.data;
                }
            };
            exports_21("ExpiryCacheMap", ExpiryCacheMap);
        }
    };
});
System.register("core/clients/options/cachingOptions", ["core/configuration", "core/clients/definitions/iOptions"], function (exports_22, context_22) {
    "use strict";
    var configuration_3, iOptions_2, CachingOptions;
    var __moduleName = context_22 && context_22.id;
    return {
        setters: [
            function (configuration_3_1) {
                configuration_3 = configuration_3_1;
            },
            function (iOptions_2_1) {
                iOptions_2 = iOptions_2_1;
            }
        ],
        execute: function () {
            CachingOptions = class CachingOptions extends configuration_3.OptionsWithFallback {
                constructor(config, section, fallbackSection = null) {
                    super(config, section, fallbackSection);
                }
                get duration() {
                    const durationMin = this.getOrDefault(iOptions_2.CachingContributions.CacheDuration, 0);
                    // convert to milliseconds
                    return durationMin * 60000;
                }
            };
            exports_22("CachingOptions", CachingOptions);
        }
    };
});
System.register("core/clients/options/httpOptions", ["core/configuration", "core/clients"], function (exports_23, context_23) {
    "use strict";
    var configuration_4, clients_1, HttpOptions;
    var __moduleName = context_23 && context_23.id;
    return {
        setters: [
            function (configuration_4_1) {
                configuration_4 = configuration_4_1;
            },
            function (clients_1_1) {
                clients_1 = clients_1_1;
            }
        ],
        execute: function () {
            HttpOptions = class HttpOptions extends configuration_4.OptionsWithFallback {
                constructor(config, section, fallbackSection = null) {
                    super(config, section, fallbackSection);
                }
                get strictSSL() {
                    return this.getOrDefault(clients_1.HttpContributions.StrictSSL, true);
                }
            };
            exports_23("HttpOptions", HttpOptions);
        }
    };
});
System.register("core/clients/requests/abstractClientRequest", ["core/clients/caching/expiryCacheMap", "core/clients/definitions/clientResponses"], function (exports_24, context_24) {
    "use strict";
    var expiryCacheMap_1, clientResponses_1, AbstractClientRequest;
    var __moduleName = context_24 && context_24.id;
    return {
        setters: [
            function (expiryCacheMap_1_1) {
                expiryCacheMap_1 = expiryCacheMap_1_1;
            },
            function (clientResponses_1_1) {
                clientResponses_1 = clientResponses_1_1;
            }
        ],
        execute: function () {
            AbstractClientRequest = class AbstractClientRequest {
                constructor(options) {
                    this.cache = new expiryCacheMap_1.ExpiryCacheMap(options);
                }
                createCachedResponse(cacheKey, status, data, rejected = false, source = clientResponses_1.ClientResponseSource.remote) {
                    const cacheEnabled = this.cache.options.duration > 0;
                    if (cacheEnabled) {
                        //  cache reponse (don't return, keep immutable)
                        this.cache.set(cacheKey, {
                            source: clientResponses_1.ClientResponseSource.cache,
                            status,
                            data,
                            rejected
                        });
                    }
                    // return original fetched data
                    return {
                        source,
                        status,
                        data,
                        rejected
                    };
                }
            };
            exports_24("AbstractClientRequest", AbstractClientRequest);
        }
    };
});
System.register("core/clients/helpers/urlHelpers", [], function (exports_25, context_25) {
    "use strict";
    var RegistryProtocols;
    var __moduleName = context_25 && context_25.id;
    function getProtocolFromUrl(url) {
        const { parse } = require('url');
        const sourceUrl = parse(url);
        const registryProtocol = sourceUrl.protocol === null ?
            RegistryProtocols.file :
            RegistryProtocols[sourceUrl.protocol.substr(0, sourceUrl.protocol.length - 1)];
        return registryProtocol || RegistryProtocols.file;
    }
    exports_25("getProtocolFromUrl", getProtocolFromUrl);
    function createUrl(baseUrl, queryParams) {
        const query = buildQueryParams(queryParams);
        const slashedUrl = query.length > 0 ?
            stripEndSlash(baseUrl) :
            baseUrl;
        return slashedUrl + query;
    }
    exports_25("createUrl", createUrl);
    function buildQueryParams(queryParams) {
        let query = '';
        if (queryParams) {
            query = Object.keys(queryParams)
                .map(key => `${key}=${queryParams[key]}`)
                .join('&');
            query = (query.length > 0) ? '?' + query : '';
        }
        return query;
    }
    function stripEndSlash(url) {
        return url.endsWith('/') ? url.substr(url.length - 1) : url;
    }
    function ensureEndSlash(url) {
        return url.endsWith('/') ? url : url + '/';
    }
    exports_25("ensureEndSlash", ensureEndSlash);
    return {
        setters: [],
        execute: function () {
            (function (RegistryProtocols) {
                RegistryProtocols["file"] = "file:";
                RegistryProtocols["http"] = "http:";
                RegistryProtocols["https"] = "https:";
            })(RegistryProtocols || (RegistryProtocols = {}));
            exports_25("RegistryProtocols", RegistryProtocols);
        }
    };
});
System.register("core/clients", ["core/clients/definitions/clientResponses", "core/clients/definitions/clientRequests", "core/clients/definitions/iOptions", "core/clients/caching/expiryCacheMap", "core/clients/options/cachingOptions", "core/clients/options/httpOptions", "core/clients/requests/abstractClientRequest", "core/clients/helpers/urlHelpers"], function (exports_26, context_26) {
    "use strict";
    var __moduleName = context_26 && context_26.id;
    var exportedNames_1 = {
        "UrlHelpers": true
    };
    function exportStar_6(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default" && !exportedNames_1.hasOwnProperty(n)) exports[n] = m[n];
        }
        exports_26(exports);
    }
    return {
        setters: [
            function (clientResponses_2_1) {
                exportStar_6(clientResponses_2_1);
            },
            function (clientRequests_1_1) {
                exportStar_6(clientRequests_1_1);
            },
            function (iOptions_3_1) {
                exportStar_6(iOptions_3_1);
            },
            function (expiryCacheMap_2_1) {
                exportStar_6(expiryCacheMap_2_1);
            },
            function (cachingOptions_1_1) {
                exportStar_6(cachingOptions_1_1);
            },
            function (httpOptions_1_1) {
                exportStar_6(httpOptions_1_1);
            },
            function (abstractClientRequest_1_1) {
                exportStar_6(abstractClientRequest_1_1);
            },
            function (UrlHelpers_1) {
                exports_26("UrlHelpers", UrlHelpers_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("presentation/extension/options/suggestionsOptions", [], function (exports_27, context_27) {
    "use strict";
    var SuggestionContributions, SuggestionsOptions;
    var __moduleName = context_27 && context_27.id;
    return {
        setters: [],
        execute: function () {
            (function (SuggestionContributions) {
                // DefaultVersionPrefix = 'versionlens.suggestions.defaultVersionPrefix',
                SuggestionContributions["ShowOnStartup"] = "suggestions.showOnStartup";
                SuggestionContributions["ShowPrereleasesOnStartup"] = "suggestions.showPrereleasesOnStartup";
            })(SuggestionContributions || (SuggestionContributions = {}));
            SuggestionsOptions = class SuggestionsOptions {
                constructor(config) {
                    this.config = config;
                }
                get showOnStartup() {
                    return this.config.get(SuggestionContributions.ShowOnStartup);
                }
                get showPrereleasesOnStartup() {
                    return this.config.get(SuggestionContributions.ShowPrereleasesOnStartup);
                }
            };
            exports_27("SuggestionsOptions", SuggestionsOptions);
        }
    };
});
System.register("presentation/extension/options/statusesOptions", [], function (exports_28, context_28) {
    "use strict";
    var StatusesContributions, StatusesOptions;
    var __moduleName = context_28 && context_28.id;
    return {
        setters: [],
        execute: function () {
            (function (StatusesContributions) {
                StatusesContributions["ShowOnStartup"] = "statuses.showOnStartup";
                StatusesContributions["NotInstalledColour"] = "statuses.notInstalledColour";
                StatusesContributions["InstalledColour"] = "statuses.installedColour";
                StatusesContributions["OutdatedColour"] = "statuses.outdatedColour";
                StatusesContributions["prereleaseInstalledColour"] = "statuses.prereleaseInstalledColour";
            })(StatusesContributions || (StatusesContributions = {}));
            StatusesOptions = class StatusesOptions {
                constructor(config) {
                    this.config = config;
                }
                get showOnStartup() {
                    return this.config.get(StatusesContributions.ShowOnStartup);
                }
                get installedColour() {
                    return this.config.get(StatusesContributions.InstalledColour);
                }
                get notInstalledColour() {
                    return this.config.get(StatusesContributions.NotInstalledColour);
                }
                get outdatedColour() {
                    return this.config.get(StatusesContributions.OutdatedColour);
                }
                get prereleaseInstalledColour() {
                    return this.config.get(StatusesContributions.prereleaseInstalledColour);
                }
            };
            exports_28("StatusesOptions", StatusesOptions);
        }
    };
});
System.register("presentation/extension/versionLensExtension", ["core/logging", "core/clients", "presentation/extension", "presentation/extension/options/suggestionsOptions", "presentation/extension/options/statusesOptions"], function (exports_29, context_29) {
    "use strict";
    var logging_1, clients_2, extension_1, suggestionsOptions_1, statusesOptions_1, SuggestionIndicators, VersionLensExtension, _extensionSingleton;
    var __moduleName = context_29 && context_29.id;
    function registerExtension(config, outputChannel) {
        _extensionSingleton = new VersionLensExtension(config, outputChannel);
        return _extensionSingleton;
    }
    exports_29("registerExtension", registerExtension);
    return {
        setters: [
            function (logging_1_1) {
                logging_1 = logging_1_1;
            },
            function (clients_2_1) {
                clients_2 = clients_2_1;
            },
            function (extension_1_1) {
                extension_1 = extension_1_1;
            },
            function (suggestionsOptions_1_1) {
                suggestionsOptions_1 = suggestionsOptions_1_1;
            },
            function (statusesOptions_1_1) {
                statusesOptions_1 = statusesOptions_1_1;
            }
        ],
        execute: function () {
            (function (SuggestionIndicators) {
                SuggestionIndicators["Update"] = "\u2191";
                SuggestionIndicators["Revert"] = "\u2193";
                SuggestionIndicators["OpenNewWindow"] = "\u29C9";
            })(SuggestionIndicators || (SuggestionIndicators = {}));
            exports_29("SuggestionIndicators", SuggestionIndicators);
            VersionLensExtension = /** @class */ (() => {
                class VersionLensExtension {
                    constructor(config, outputChannel) {
                        this.config = config;
                        // instantiate contrib options
                        this.logging = new logging_1.LoggingOptions(config, 'logging');
                        this.caching = new clients_2.CachingOptions(config, 'caching');
                        this.http = new clients_2.HttpOptions(config, 'http');
                        this.suggestions = new suggestionsOptions_1.SuggestionsOptions(config);
                        this.statuses = new statusesOptions_1.StatusesOptions(config);
                        // instantiate setContext options
                        this.state = new extension_1.VersionLensState(this);
                        this.outputChannel = outputChannel;
                    }
                }
                VersionLensExtension.extensionName = 'VersionLens';
                return VersionLensExtension;
            })();
            exports_29("VersionLensExtension", VersionLensExtension);
            _extensionSingleton = null;
            exports_29("default", _extensionSingleton);
        }
    };
});
System.register("core/packages/definitions/iPackageDependency", [], function (exports_30, context_30) {
    "use strict";
    var __moduleName = context_30 && context_30.id;
    return {
        setters: [],
        execute: function () {
            ;
        }
    };
});
System.register("core/packages/definitions/packageRequest", [], function (exports_31, context_31) {
    "use strict";
    var __moduleName = context_31 && context_31.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages/models/packageResponse", [], function (exports_32, context_32) {
    "use strict";
    var PackageResponse;
    var __moduleName = context_32 && context_32.id;
    return {
        setters: [],
        execute: function () {
            PackageResponse = class PackageResponse {
            };
            exports_32("PackageResponse", PackageResponse);
        }
    };
});
System.register("core/packages/definitions/packageResponse", [], function (exports_33, context_33) {
    "use strict";
    var PackageResponseErrors;
    var __moduleName = context_33 && context_33.id;
    return {
        setters: [],
        execute: function () {
            (function (PackageResponseErrors) {
                PackageResponseErrors[PackageResponseErrors["None"] = 0] = "None";
                PackageResponseErrors[PackageResponseErrors["NotFound"] = 1] = "NotFound";
                PackageResponseErrors[PackageResponseErrors["NotSupported"] = 2] = "NotSupported";
                PackageResponseErrors[PackageResponseErrors["GitNotFound"] = 3] = "GitNotFound";
                PackageResponseErrors[PackageResponseErrors["InvalidVersion"] = 4] = "InvalidVersion";
                PackageResponseErrors[PackageResponseErrors["Unexpected"] = 5] = "Unexpected";
            })(PackageResponseErrors || (PackageResponseErrors = {}));
            exports_33("PackageResponseErrors", PackageResponseErrors);
            ;
        }
    };
});
System.register("core/packages/definitions/packageDocument", [], function (exports_34, context_34) {
    "use strict";
    var PackageSourceTypes, PackageVersionTypes, PackageVersionStatus, PackageSuggestionFlags;
    var __moduleName = context_34 && context_34.id;
    return {
        setters: [],
        execute: function () {
            (function (PackageSourceTypes) {
                PackageSourceTypes["Directory"] = "directory";
                PackageSourceTypes["File"] = "file";
                PackageSourceTypes["Git"] = "git";
                PackageSourceTypes["Github"] = "github";
                PackageSourceTypes["Registry"] = "registry";
            })(PackageSourceTypes || (PackageSourceTypes = {}));
            exports_34("PackageSourceTypes", PackageSourceTypes);
            (function (PackageVersionTypes) {
                PackageVersionTypes["Version"] = "version";
                PackageVersionTypes["Range"] = "range";
                PackageVersionTypes["Tag"] = "tag";
                PackageVersionTypes["Alias"] = "alias";
                PackageVersionTypes["Committish"] = "committish";
            })(PackageVersionTypes || (PackageVersionTypes = {}));
            exports_34("PackageVersionTypes", PackageVersionTypes);
            (function (PackageVersionStatus) {
                PackageVersionStatus["NotFound"] = "package not found";
                PackageVersionStatus["NotAuthorized"] = "not authorized";
                PackageVersionStatus["NotSupported"] = "not supported";
                PackageVersionStatus["ConnectionRefused"] = "connection refused";
                PackageVersionStatus["Invalid"] = "invalid entry";
                PackageVersionStatus["NoMatch"] = "no match";
                PackageVersionStatus["Satisfies"] = "satisfies";
                PackageVersionStatus["Latest"] = "latest";
                PackageVersionStatus["Fixed"] = "fixed";
            })(PackageVersionStatus || (PackageVersionStatus = {}));
            exports_34("PackageVersionStatus", PackageVersionStatus);
            (function (PackageSuggestionFlags) {
                // bitwise
                PackageSuggestionFlags[PackageSuggestionFlags["status"] = 1] = "status";
                PackageSuggestionFlags[PackageSuggestionFlags["release"] = 2] = "release";
                PackageSuggestionFlags[PackageSuggestionFlags["prerelease"] = 4] = "prerelease";
                PackageSuggestionFlags[PackageSuggestionFlags["tag"] = 8] = "tag";
            })(PackageSuggestionFlags || (PackageSuggestionFlags = {}));
            exports_34("PackageSuggestionFlags", PackageSuggestionFlags);
        }
    };
});
System.register("core/packages/definitions/semverSpec", [], function (exports_35, context_35) {
    "use strict";
    var __moduleName = context_35 && context_35.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages/definitions/iPackageClient", [], function (exports_36, context_36) {
    "use strict";
    var __moduleName = context_36 && context_36.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages/definitions/packageClientContext", [], function (exports_37, context_37) {
    "use strict";
    var __moduleName = context_37 && context_37.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages/options/iPackageProviderOptions", [], function (exports_38, context_38) {
    "use strict";
    var __moduleName = context_38 && context_38.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages/options/iPackageClientOptions", [], function (exports_39, context_39) {
    "use strict";
    var __moduleName = context_39 && context_39.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages/helpers/versionHelpers", ["core/packages/definitions/packageDocument"], function (exports_40, context_40) {
    "use strict";
    var packageDocument_1, formatTagNameRegex, loosePrereleases, isfourSegmentVersionRegex, commonReleaseIdentities, extractSymbolFromVersionRegex, semverLeadingChars;
    var __moduleName = context_40 && context_40.id;
    function filterPrereleasesFromDistTags(distTags) {
        const { prerelease } = require("semver");
        const prereleases = [];
        Object.keys(distTags)
            .forEach((key) => {
            if (prerelease(distTags[key]))
                prereleases.push(distTags[key]);
        });
        return prereleases;
    }
    exports_40("filterPrereleasesFromDistTags", filterPrereleasesFromDistTags);
    function extractVersionsFromMap(versions) {
        return versions.map(function (pnv) {
            return pnv.version;
        });
    }
    exports_40("extractVersionsFromMap", extractVersionsFromMap);
    function extractTaggedVersions(versions) {
        const { prerelease } = require('semver');
        const results = [];
        versions.forEach(function (version) {
            const prereleaseComponents = prerelease(version);
            const isPrerelease = !!prereleaseComponents && prereleaseComponents.length > 0;
            if (isPrerelease) {
                const regexResult = formatTagNameRegex.exec(prereleaseComponents[0]);
                const name = regexResult[0].toLowerCase();
                results.push({
                    name,
                    version
                });
            }
        });
        return results;
    }
    exports_40("extractTaggedVersions", extractTaggedVersions);
    function splitReleasesFromArray(versions) {
        const { prerelease } = require('semver');
        const releases = [];
        const prereleases = [];
        versions.forEach(function (version) {
            if (prerelease(version))
                prereleases.push(version);
            else
                releases.push(version);
        });
        return { releases, prereleases };
    }
    exports_40("splitReleasesFromArray", splitReleasesFromArray);
    function lteFromArray(versions, version) {
        const { lte } = require('semver');
        return versions.filter(function (testVersion) {
            return lte(testVersion, version);
        });
    }
    exports_40("lteFromArray", lteFromArray);
    function removeFourSegmentVersionsFromArray(versions) {
        return versions.filter(function (version) {
            return isFourSegmentedVersion(version) === false;
        });
    }
    exports_40("removeFourSegmentVersionsFromArray", removeFourSegmentVersionsFromArray);
    function isFixedVersion(versionToCheck) {
        const { Range, valid } = require('semver');
        const testRange = new Range(versionToCheck, loosePrereleases);
        return valid(versionToCheck) !== null && testRange.set[0][0].operator === "";
    }
    exports_40("isFixedVersion", isFixedVersion);
    function isFourSegmentedVersion(versionToCheck) {
        return isfourSegmentVersionRegex.test(versionToCheck);
    }
    exports_40("isFourSegmentedVersion", isFourSegmentedVersion);
    function friendlifyPrereleaseName(prereleaseName) {
        const filteredNames = [];
        commonReleaseIdentities.forEach(function (group) {
            return group.forEach(commonName => {
                const exp = new RegExp(`(.+-)${commonName}`, 'i');
                if (exp.test(prereleaseName.toLowerCase())) {
                    filteredNames.push(commonName);
                }
            });
        });
        return (filteredNames.length === 0) ?
            null :
            filteredNames[0];
    }
    exports_40("friendlifyPrereleaseName", friendlifyPrereleaseName);
    function parseSemver(packageVersion) {
        const { valid, validRange } = require('semver');
        const isVersion = valid(packageVersion, loosePrereleases);
        const isRange = validRange(packageVersion, loosePrereleases);
        return {
            rawVersion: packageVersion,
            type: !!isVersion ?
                packageDocument_1.PackageVersionTypes.Version :
                !!isRange ? packageDocument_1.PackageVersionTypes.Range :
                    null,
        };
    }
    exports_40("parseSemver", parseSemver);
    function filterPrereleasesGtMinRange(versionRange, prereleases) {
        const { SemVer, gt, maxSatisfying, minVersion, validRange } = require('semver');
        const prereleaseGroupMap = {};
        // for each prerelease version;
        // group prereleases by x.x.x-{name}*.x
        prereleases.forEach(function (prereleaseVersion) {
            const spec = new SemVer(prereleaseVersion, loosePrereleases);
            const prereleaseKey = friendlifyPrereleaseName(prereleaseVersion) || spec.prerelease[0];
            prereleaseGroupMap[prereleaseKey] = prereleaseGroupMap[prereleaseKey] || [];
            prereleaseGroupMap[prereleaseKey].push(prereleaseVersion);
        });
        // check we have a valid range (handles non-semver errors)
        const isValidRange = validRange(versionRange, loosePrereleases) !== null;
        const minVersionFromRange = isValidRange ?
            minVersion(versionRange, loosePrereleases) :
            versionRange;
        const gtfn = isValidRange ? gt : maxSatisfying;
        // for each group;
        // extract versions that are greater than the min-range (one from each group)
        const filterPrereleases = [];
        Object.keys(prereleaseGroupMap)
            .forEach(function (prereleaseKey) {
            const versions = prereleaseGroupMap[prereleaseKey];
            const testMaxVersion = versions[versions.length - 1];
            const isPrereleaseGt = gtfn(testMaxVersion, minVersionFromRange, loosePrereleases);
            if (isPrereleaseGt)
                filterPrereleases.push(testMaxVersion);
        });
        return filterPrereleases;
    }
    exports_40("filterPrereleasesGtMinRange", filterPrereleasesGtMinRange);
    function filterSemverVersions(versions) {
        const { validRange } = require('semver');
        const semverVersions = [];
        versions.forEach(version => {
            if (validRange(version, loosePrereleases))
                semverVersions.push(version);
        });
        return semverVersions;
    }
    exports_40("filterSemverVersions", filterSemverVersions);
    function formatWithExistingLeading(existingVersion, newVersion) {
        const regExResult = extractSymbolFromVersionRegex.exec(existingVersion);
        const leading = regExResult && regExResult[1];
        if (!leading || !semverLeadingChars.includes(leading))
            return newVersion;
        return `${leading}${newVersion}`;
    }
    exports_40("formatWithExistingLeading", formatWithExistingLeading);
    return {
        setters: [
            function (packageDocument_1_1) {
                packageDocument_1 = packageDocument_1_1;
            }
        ],
        execute: function () {
            exports_40("formatTagNameRegex", formatTagNameRegex = /^[^0-9\-]*/);
            exports_40("loosePrereleases", loosePrereleases = { loose: true, includePrerelease: true });
            isfourSegmentVersionRegex = /^(\d+\.)(\d+\.)(\d+\.)(\*|\d+)$/g;
            commonReleaseIdentities = [
                ['legacy'],
                ['alpha', 'preview', 'a'],
                ['beta', 'b'],
                ['next'],
                ['milestone', 'm'],
                ['rc', 'cr'],
                ['snapshot'],
                ['release', 'final', 'ga'],
                ['sp']
            ];
            exports_40("extractSymbolFromVersionRegex", extractSymbolFromVersionRegex = /^([^0-9]*)?.*$/);
            exports_40("semverLeadingChars", semverLeadingChars = ['^', '~', '<', '<=', '>', '>=', '~>']);
        }
    };
});
System.register("core/packages/factories/packageSuggestionFactory", ["core/packages/definitions/packageDocument", "core/packages/helpers/versionHelpers"], function (exports_41, context_41) {
    "use strict";
    var packageDocument_2, versionHelpers_1;
    var __moduleName = context_41 && context_41.id;
    function createSuggestionTags(versionRange, releases, prereleases) {
        const { maxSatisfying } = require("semver");
        const suggestions = [];
        // check for a release
        let satisfiesVersion = maxSatisfying(releases, versionRange, versionHelpers_1.loosePrereleases);
        if (!satisfiesVersion) {
            // lookup prereleases
            satisfiesVersion = maxSatisfying(prereleases, versionRange, versionHelpers_1.loosePrereleases);
        }
        // get the latest release
        const latestVersion = maxSatisfying(releases, "*");
        const isLatest = latestVersion === satisfiesVersion;
        const noSuggestionNeeded = versionRange.includes(satisfiesVersion);
        if (releases.length === 0 && prereleases.length === 0)
            // no match
            suggestions.push(createNoMatch());
        else if (!satisfiesVersion)
            // no match
            suggestions.push(createNoMatch(), 
            // suggest latestVersion
            createLatest(latestVersion));
        else if (isLatest && noSuggestionNeeded)
            // latest
            suggestions.push(createMatchesLatest());
        else if (isLatest)
            suggestions.push(
            // satisfies latest
            createSatisifiesLatest(), 
            // suggest latestVersion
            createLatest(latestVersion));
        else if (satisfiesVersion) {
            if (versionHelpers_1.isFixedVersion(versionRange)) {
                suggestions.push(
                // fixed
                createFixedStatus(versionRange), 
                // suggest latestVersion
                createLatest(latestVersion));
            }
            else {
                suggestions.push(
                // satisfies >x.y.z <x.y.z
                createSuggestion(packageDocument_2.PackageVersionStatus.Satisfies, satisfiesVersion, noSuggestionNeeded ?
                    packageDocument_2.PackageSuggestionFlags.status :
                    packageDocument_2.PackageSuggestionFlags.release), 
                // suggest latestVersion
                createLatest(latestVersion));
            }
        }
        // roll up prereleases
        const maxSatisfyingPrereleases = versionHelpers_1.filterPrereleasesGtMinRange(versionRange, prereleases);
        // group prereleases
        const taggedVersions = versionHelpers_1.extractTaggedVersions(maxSatisfyingPrereleases);
        taggedVersions.forEach((pvn) => {
            if (pvn.name === 'latest')
                return;
            if (pvn.version === satisfiesVersion)
                return;
            if (versionRange.includes(pvn.version))
                return;
            suggestions.push({
                name: pvn.name,
                version: pvn.version,
                flags: packageDocument_2.PackageSuggestionFlags.prerelease
            });
        });
        return suggestions;
    }
    exports_41("createSuggestionTags", createSuggestionTags);
    function createNotFound() {
        return {
            name: packageDocument_2.PackageVersionStatus.NotFound,
            version: '',
            flags: packageDocument_2.PackageSuggestionFlags.status
        };
    }
    exports_41("createNotFound", createNotFound);
    function createConnectionRefused() {
        return {
            name: packageDocument_2.PackageVersionStatus.ConnectionRefused,
            version: '',
            flags: packageDocument_2.PackageSuggestionFlags.status
        };
    }
    exports_41("createConnectionRefused", createConnectionRefused);
    function createNotAuthorized() {
        return {
            name: packageDocument_2.PackageVersionStatus.NotAuthorized,
            version: '',
            flags: packageDocument_2.PackageSuggestionFlags.status
        };
    }
    exports_41("createNotAuthorized", createNotAuthorized);
    function createInvalid(requestedVersion) {
        return {
            name: packageDocument_2.PackageVersionStatus.Invalid,
            version: requestedVersion,
            flags: packageDocument_2.PackageSuggestionFlags.status
        };
    }
    exports_41("createInvalid", createInvalid);
    function createNotSupported() {
        return {
            name: packageDocument_2.PackageVersionStatus.NotSupported,
            version: '',
            flags: packageDocument_2.PackageSuggestionFlags.status
        };
    }
    exports_41("createNotSupported", createNotSupported);
    function createNoMatch() {
        return {
            name: packageDocument_2.PackageVersionStatus.NoMatch,
            version: '',
            flags: packageDocument_2.PackageSuggestionFlags.status
        };
    }
    exports_41("createNoMatch", createNoMatch);
    function createLatest(requestedVersion) {
        // treats requestedVersion as latest version
        // if no requestedVersion then uses the 'latest' tag instead
        return {
            name: packageDocument_2.PackageVersionStatus.Latest,
            version: requestedVersion || 'latest',
            flags: requestedVersion ?
                packageDocument_2.PackageSuggestionFlags.release :
                packageDocument_2.PackageSuggestionFlags.tag
        };
    }
    exports_41("createLatest", createLatest);
    function createMatchesLatest() {
        return {
            name: packageDocument_2.PackageVersionStatus.Latest,
            version: '',
            flags: packageDocument_2.PackageSuggestionFlags.status
        };
    }
    exports_41("createMatchesLatest", createMatchesLatest);
    function createSatisifiesLatest() {
        return createSuggestion(packageDocument_2.PackageVersionStatus.Satisfies, 'latest', packageDocument_2.PackageSuggestionFlags.status);
    }
    exports_41("createSatisifiesLatest", createSatisifiesLatest);
    function createFixedStatus(version) {
        return createSuggestion(packageDocument_2.PackageVersionStatus.Fixed, version, packageDocument_2.PackageSuggestionFlags.status);
    }
    exports_41("createFixedStatus", createFixedStatus);
    function createSuggestion(name, version, flags) {
        return { name, version, flags };
    }
    exports_41("createSuggestion", createSuggestion);
    return {
        setters: [
            function (packageDocument_2_1) {
                packageDocument_2 = packageDocument_2_1;
            },
            function (versionHelpers_1_1) {
                versionHelpers_1 = versionHelpers_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("core/packages/factories/packageDocumentFactory", ["core/packages/factories/packageSuggestionFactory", "core/packages/definitions/packageDocument"], function (exports_42, context_42) {
    "use strict";
    var SuggestFactory, packageDocument_3;
    var __moduleName = context_42 && context_42.id;
    function createNotFound(providerName, requested, type, response) {
        const source = packageDocument_3.PackageSourceTypes.Registry;
        const suggestions = [
            SuggestFactory.createNotFound()
        ];
        return {
            providerName,
            source,
            type,
            requested,
            resolved: null,
            suggestions,
            response
        };
    }
    exports_42("createNotFound", createNotFound);
    function createConnectionRefused(providerName, requested, type, response) {
        const source = packageDocument_3.PackageSourceTypes.Registry;
        const suggestions = [
            SuggestFactory.createConnectionRefused()
        ];
        return {
            providerName,
            source,
            type,
            requested,
            resolved: null,
            suggestions,
            response
        };
    }
    exports_42("createConnectionRefused", createConnectionRefused);
    function createNotAuthorized(providerName, requested, type, response) {
        const source = packageDocument_3.PackageSourceTypes.Registry;
        const suggestions = [
            SuggestFactory.createNotAuthorized()
        ];
        return {
            providerName,
            source,
            type,
            requested,
            resolved: null,
            suggestions,
            response
        };
    }
    exports_42("createNotAuthorized", createNotAuthorized);
    function createInvalidVersion(providerName, requested, response, type) {
        const source = packageDocument_3.PackageSourceTypes.Registry;
        const suggestions = [
            SuggestFactory.createInvalid(''),
            SuggestFactory.createLatest(),
        ];
        return {
            providerName,
            source,
            type,
            requested,
            response,
            resolved: null,
            suggestions
        };
    }
    exports_42("createInvalidVersion", createInvalidVersion);
    function createNotSupported(providerName, requested, response, type) {
        const source = packageDocument_3.PackageSourceTypes.Registry;
        const suggestions = [
            SuggestFactory.createNotSupported(),
        ];
        return {
            providerName,
            source,
            type,
            requested,
            response,
            resolved: null,
            suggestions
        };
    }
    exports_42("createNotSupported", createNotSupported);
    function createGitFailed(providerName, requested, response, type) {
        const source = packageDocument_3.PackageSourceTypes.Git;
        const suggestions = [
            SuggestFactory.createNotFound(),
        ];
        return {
            providerName,
            source,
            type,
            requested,
            response,
            resolved: null,
            suggestions
        };
    }
    exports_42("createGitFailed", createGitFailed);
    function createNoMatch(providerName, source, type, requested, response, latestVersion) {
        const suggestions = [
            SuggestFactory.createNoMatch(),
            SuggestFactory.createLatest(latestVersion),
        ];
        return {
            providerName,
            source,
            type,
            requested,
            response,
            resolved: null,
            suggestions
        };
    }
    exports_42("createNoMatch", createNoMatch);
    function createFourSegment(providerName, requested, response, type) {
        const source = packageDocument_3.PackageSourceTypes.Registry;
        const suggestions = [];
        return {
            providerName,
            source,
            type,
            requested,
            response,
            resolved: null,
            suggestions
        };
    }
    exports_42("createFourSegment", createFourSegment);
    function createFixed(providerName, source, requested, response, type, fixedVersion) {
        const suggestions = [
            SuggestFactory.createFixedStatus(fixedVersion)
        ];
        return {
            providerName,
            source,
            type,
            requested,
            response,
            resolved: null,
            suggestions
        };
    }
    exports_42("createFixed", createFixed);
    return {
        setters: [
            function (SuggestFactory_1) {
                SuggestFactory = SuggestFactory_1;
            },
            function (packageDocument_3_1) {
                packageDocument_3 = packageDocument_3_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("core/packages/factories/packageRequestFactory", ["core/packages"], function (exports_43, context_43) {
    "use strict";
    var packages_1;
    var __moduleName = context_43 && context_43.id;
    async function executeDependencyRequests(packagePath, client, dependencies, context) {
        const providerName = client.config.options.providerName;
        const { includePrereleases, clientData, } = context;
        const results = [];
        const promises = dependencies.map(function (dependency) {
            // build the client request
            const { name, version } = dependency.packageInfo;
            const clientRequest = {
                providerName,
                includePrereleases,
                clientData,
                dependency,
                package: {
                    name,
                    version,
                    path: packagePath,
                },
                attempt: 0
            };
            // execute request
            const promisedDependency = packages_1.RequestFactory.executePackageRequest(client, clientRequest);
            // flatten responses
            return promisedDependency.then(function (responses) {
                if (Array.isArray(responses))
                    results.push(...responses);
                else
                    results.push(responses);
            });
        });
        return Promise.all(promises).then(_ => results);
    }
    exports_43("executeDependencyRequests", executeDependencyRequests);
    async function executePackageRequest(client, request) {
        client.logger.debug(`Queued package: %s`, request.package.name);
        return client.fetchPackage(request)
            .then(function (response) {
            client.logger.info('Fetched package from %s: %s@%s', response.response.source, request.package.name, request.package.version);
            if (request.includePrereleases === false) {
                response.suggestions = response.suggestions.filter(suggestion => !(suggestion.flags & packages_1.PackageSuggestionFlags.prerelease));
            }
            return packages_1.ResponseFactory.createSuccess(request, response);
        })
            .catch(function (error) {
            client.logger.error(`%s caught an exception.\n Package: %j\n Error: %j`, executePackageRequest.name, request.package, error);
            return Promise.reject(error);
        });
    }
    exports_43("executePackageRequest", executePackageRequest);
    return {
        setters: [
            function (packages_1_1) {
                packages_1 = packages_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("core/packages/factories/packageResponseFactory", ["core/packages/definitions/packageResponse"], function (exports_44, context_44) {
    "use strict";
    var packageResponse_1;
    var __moduleName = context_44 && context_44.id;
    function createResponseStatus(source, status) {
        return {
            source,
            status
        };
    }
    exports_44("createResponseStatus", createResponseStatus);
    function createSuccess(request, response) {
        // map the documents to responses
        return response.suggestions.map(function (suggestion, order) {
            return {
                providerName: response.providerName,
                source: response.source,
                type: response.type,
                nameRange: request.dependency.nameRange,
                versionRange: request.dependency.versionRange,
                order,
                requested: response.requested,
                resolved: response.resolved,
                suggestion,
            };
        });
    }
    exports_44("createSuccess", createSuccess);
    function createUnexpected(providerName, request, response) {
        const { nameRange, versionRange } = request.dependency;
        const error = {
            providerName,
            nameRange,
            versionRange,
            order: 0,
            requested: request.package,
            error: packageResponse_1.PackageResponseErrors.Unexpected,
            errorMessage: response.data,
            response
        };
        return error;
    }
    exports_44("createUnexpected", createUnexpected);
    return {
        setters: [
            function (packageResponse_1_1) {
                packageResponse_1 = packageResponse_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("core/packages/parsers/jsonPackageParser", [], function (exports_45, context_45) {
    "use strict";
    var __moduleName = context_45 && context_45.id;
    function extractPackageDependenciesFromJson(json, filterPropertyNames) {
        const jsonErrors = [];
        const jsonParser = require("jsonc-parser");
        const jsonTree = jsonParser.parseTree(json, jsonErrors);
        if (!jsonTree || jsonTree.children.length === 0 || jsonErrors.length > 0)
            return [];
        return extractFromNodes(jsonTree.children, filterPropertyNames);
    }
    exports_45("extractPackageDependenciesFromJson", extractPackageDependenciesFromJson);
    function extractFromNodes(topLevelNodes, includePropertyNames) {
        const collector = [];
        topLevelNodes.forEach(function (node) {
            const [keyEntry, valueEntry] = node.children;
            if (includePropertyNames.includes(keyEntry.value) === false)
                return;
            collectDependencyNodes(valueEntry.children, null, '', collector);
        });
        return collector;
    }
    exports_45("extractFromNodes", extractFromNodes);
    function collectDependencyNodes(nodes, parentKey, filterName, collector = []) {
        nodes.forEach(function (node) {
            const [keyEntry, valueEntry] = node.children;
            if (valueEntry.type == "string" &&
                (filterName.length === 0 || keyEntry.value === filterName)) {
                const dependencyLens = createFromProperty(parentKey || keyEntry, valueEntry);
                collector.push(dependencyLens);
            }
            else if (valueEntry.type == "object") {
                collectDependencyNodes(valueEntry.children, keyEntry, 'version', collector);
            }
        });
    }
    function createFromProperty(keyEntry, valueEntry) {
        const nameRange = {
            start: keyEntry.offset,
            end: keyEntry.offset,
        };
        // +1 and -1 to be inside quotes
        const versionRange = {
            start: valueEntry.offset + 1,
            end: valueEntry.offset + valueEntry.length - 1,
        };
        const packageInfo = {
            name: keyEntry.value,
            version: valueEntry.value
        };
        return {
            nameRange,
            versionRange,
            packageInfo
        };
    }
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages/parsers/yamlPackageParser", [], function (exports_46, context_46) {
    "use strict";
    var __moduleName = context_46 && context_46.id;
    function extractPackageDependenciesFromYaml(yaml, filterPropertyNames) {
        const { Document, parseCST } = require('yaml');
        // verbose parsing to handle CRLF scenarios
        const cst = parseCST(yaml);
        // create and parse the document
        const yamlDoc = new Document({ keepCstNodes: true }).parse(cst[0]);
        if (!yamlDoc || !yamlDoc.contents || yamlDoc.errors.length > 0)
            return [];
        const opts = {
            hasCrLf: yaml.indexOf('\r\n') > 0,
            filterPropertyNames,
            yaml,
        };
        return extractDependenciesFromNodes(yamlDoc.contents.items, opts);
    }
    exports_46("extractPackageDependenciesFromYaml", extractPackageDependenciesFromYaml);
    function extractDependenciesFromNodes(topLevelNodes, opts) {
        const collector = [];
        topLevelNodes.forEach(function (pair) {
            if (opts.filterPropertyNames.includes(pair.key.value) === false)
                return;
            if (pair.value === null)
                return;
            collectDependencyNodes(pair.value.items, opts, collector);
        });
        return collector;
    }
    exports_46("extractDependenciesFromNodes", extractDependenciesFromNodes);
    function collectDependencyNodes(nodes, opts, collector) {
        nodes.forEach(function (pair) {
            // node may be in the form "no_version_dep:", which we will indicate as the latest
            if (!pair.value || (pair.value.type === 'PLAIN' && !pair.value.value)) {
                const keyRange = getRangeFromCstNode(pair.key.cstNode, opts);
                pair.value = {
                    range: [
                        keyRange.end + 2,
                        keyRange.end + 2,
                    ],
                    value: '',
                    type: null
                };
            }
            if (pair.value.type === 'MAP') {
                createDependencyLensFromMapType(pair.value.items, pair.key, opts, collector);
            }
            else if (typeof pair.value.value === 'string') {
                const dependencyLens = createDependencyLensFromPlainType(pair, opts);
                collector.push(dependencyLens);
            }
        });
    }
    function createDependencyLensFromMapType(nodes, parentKey, opts, collector) {
        nodes.forEach(function (pair) {
            // ignore empty entries
            if (!pair.value)
                return;
            if (pair.key.value === "version") {
                const keyRange = getRangeFromCstNode(parentKey.cstNode, opts);
                const nameRange = createRange(keyRange.start, keyRange.start, null);
                const valueRange = getRangeFromCstNode(pair.value.cstNode, opts);
                const versionRange = createRange(valueRange.start, valueRange.end, pair.value.type);
                const packageInfo = {
                    name: parentKey.value,
                    version: pair.value.value
                };
                collector.push({
                    nameRange,
                    versionRange,
                    packageInfo
                });
            }
        });
    }
    exports_46("createDependencyLensFromMapType", createDependencyLensFromMapType);
    function createDependencyLensFromPlainType(pair, opts) {
        const keyRange = getRangeFromCstNode(pair.key.cstNode, opts);
        const nameRange = createRange(keyRange.start, keyRange.start, null);
        let valueRange;
        if (pair.value.cstNode) {
            valueRange = getRangeFromCstNode(pair.value.cstNode, opts);
        }
        else {
            // handle blank values
            const start = pair.value.range[0];
            valueRange = { start, end: start };
        }
        const versionRange = createRange(valueRange.start, valueRange.end, pair.value.type);
        const packageInfo = {
            name: pair.key.value,
            version: pair.value.value
        };
        return {
            nameRange,
            versionRange,
            packageInfo
        };
    }
    exports_46("createDependencyLensFromPlainType", createDependencyLensFromPlainType);
    function createRange(start, end, valueType) {
        // +1 and -1 to be inside quotes
        const quoted = valueType === "QUOTE_SINGLE" || valueType === "QUOTE_DOUBLE";
        return {
            start: start + (quoted ? 1 : 0),
            end: end - (quoted ? 1 : 0),
        };
    }
    function getRangeFromCstNode(cstNode, opts) {
        const crLfLineOffset = opts.hasCrLf ?
            cstNode.rangeAsLinePos.start.line : 0;
        const start = cstNode.range.start + crLfLineOffset;
        const end = cstNode.range.end + crLfLineOffset;
        return { start, end };
    }
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("core/packages", ["core/packages/definitions/semverSpec", "core/packages/definitions/iPackageClient", "core/packages/definitions/iPackageDependency", "core/packages/definitions/packageDocument", "core/packages/definitions/packageRequest", "core/packages/definitions/packageResponse", "core/packages/definitions/packageClientContext", "core/packages/options/iPackageProviderOptions", "core/packages/options/iPackageClientOptions", "core/packages/factories/packageDocumentFactory", "core/packages/factories/packageRequestFactory", "core/packages/factories/packageResponseFactory", "core/packages/factories/packageSuggestionFactory", "core/packages/helpers/versionHelpers", "core/packages/models/packageResponse", "core/packages/parsers/jsonPackageParser", "core/packages/parsers/yamlPackageParser"], function (exports_47, context_47) {
    "use strict";
    var __moduleName = context_47 && context_47.id;
    var exportedNames_2 = {
        "DocumentFactory": true,
        "RequestFactory": true,
        "ResponseFactory": true,
        "SuggestionFactory": true,
        "VersionHelpers": true
    };
    function exportStar_7(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default" && !exportedNames_2.hasOwnProperty(n)) exports[n] = m[n];
        }
        exports_47(exports);
    }
    return {
        setters: [
            function (semverSpec_1_1) {
                exportStar_7(semverSpec_1_1);
            },
            function (iPackageClient_1_1) {
                exportStar_7(iPackageClient_1_1);
            },
            function (iPackageDependency_1_1) {
                exportStar_7(iPackageDependency_1_1);
            },
            function (packageDocument_4_1) {
                exportStar_7(packageDocument_4_1);
            },
            function (packageRequest_1_1) {
                exportStar_7(packageRequest_1_1);
            },
            function (packageResponse_2_1) {
                exportStar_7(packageResponse_2_1);
            },
            function (packageClientContext_1_1) {
                exportStar_7(packageClientContext_1_1);
            },
            function (iPackageProviderOptions_1_1) {
                exportStar_7(iPackageProviderOptions_1_1);
            },
            function (iPackageClientOptions_1_1) {
                exportStar_7(iPackageClientOptions_1_1);
            },
            function (DocumentFactory_1) {
                exports_47("DocumentFactory", DocumentFactory_1);
            },
            function (RequestFactory_1) {
                exports_47("RequestFactory", RequestFactory_1);
            },
            function (ResponseFactory_1) {
                exports_47("ResponseFactory", ResponseFactory_1);
            },
            function (SuggestionFactory_1) {
                exports_47("SuggestionFactory", SuggestionFactory_1);
            },
            function (VersionHelpers_1) {
                exports_47("VersionHelpers", VersionHelpers_1);
            },
            function (packageResponse_3_1) {
                exportStar_7(packageResponse_3_1);
            },
            function (jsonPackageParser_1_1) {
                exportStar_7(jsonPackageParser_1_1);
            },
            function (yamlPackageParser_1_1) {
                exportStar_7(yamlPackageParser_1_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("presentation/extension/models/contextState", [], function (exports_48, context_48) {
    "use strict";
    var ContextState;
    var __moduleName = context_48 && context_48.id;
    return {
        setters: [],
        execute: function () {
            ContextState = class ContextState {
                constructor(key, defaultValue) {
                    this.key = key;
                    this.change(defaultValue);
                }
                get value() {
                    return this._value;
                }
                set value(newValue) {
                    this.change(newValue);
                }
                change(newValue) {
                    this._value = newValue;
                    const { commands } = require('vscode');
                    return commands.executeCommand('setContext', this.key, newValue);
                }
            };
            exports_48("ContextState", ContextState);
        }
    };
});
System.register("presentation/extension/versionLensState", ["presentation/extension/models/contextState"], function (exports_49, context_49) {
    "use strict";
    var contextState_1, StateContributions, VersionLensState;
    var __moduleName = context_49 && context_49.id;
    return {
        setters: [
            function (contextState_1_1) {
                contextState_1 = contextState_1_1;
            }
        ],
        execute: function () {
            (function (StateContributions) {
                StateContributions["Enabled"] = "versionlens.enabled";
                StateContributions["PrereleasesEnabled"] = "versionlens.prereleasesEnabled";
                StateContributions["ProviderActive"] = "versionlens.providerActive";
                StateContributions["ProviderBusy"] = "versionlens.providerBusy";
                StateContributions["ProviderError"] = "versionlens.providerError";
                StateContributions["ProviderSupportsPrereleases"] = "versionlens.providerSupportsPrereleases";
                StateContributions["ProviderSupportsInstalledStatuses"] = "versionlens.providerSupportsInstalledStatuses";
                StateContributions["InstalledStatusesEnabled"] = "versionlens.installedStatusesEnabled";
            })(StateContributions || (StateContributions = {}));
            VersionLensState = class VersionLensState {
                constructor(extension) {
                    this.enabled = new contextState_1.ContextState(StateContributions.Enabled, extension.suggestions.showOnStartup);
                    this.prereleasesEnabled = new contextState_1.ContextState(StateContributions.PrereleasesEnabled, extension.suggestions.showPrereleasesOnStartup);
                    this.installedStatusesEnabled = new contextState_1.ContextState(StateContributions.InstalledStatusesEnabled, extension.statuses.showOnStartup);
                    this.providerActive = new contextState_1.ContextState(StateContributions.ProviderActive, false);
                    this.providerBusy = new contextState_1.ContextState(StateContributions.ProviderBusy, 0);
                    this.providerError = new contextState_1.ContextState(StateContributions.ProviderError, false);
                    this.providerSupportsPrereleases = new contextState_1.ContextState(StateContributions.ProviderSupportsPrereleases, false);
                    this.providerSupportsInstalledStatuses = new contextState_1.ContextState(StateContributions.ProviderSupportsInstalledStatuses, false);
                }
            };
            exports_49("VersionLensState", VersionLensState);
        }
    };
});
System.register("presentation/lenses/definitions/iVersionCodeLens", [], function (exports_50, context_50) {
    "use strict";
    var __moduleName = context_50 && context_50.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("presentation/lenses/versionLens", [], function (exports_51, context_51) {
    "use strict";
    var CodeLens, VersionLens;
    var __moduleName = context_51 && context_51.id;
    return {
        setters: [],
        execute: function () {
            // vscode implementations
            CodeLens = require('vscode').CodeLens;
            VersionLens = class VersionLens extends CodeLens {
                constructor(commandRange, replaceRange, packageResponse, documentUrl, replaceVersionFn) {
                    super(commandRange);
                    this.replaceRange = replaceRange || commandRange;
                    this.package = packageResponse;
                    this.documentUrl = documentUrl;
                    this.command = null;
                    this.replaceVersionFn = replaceVersionFn;
                }
                hasPackageSource(source) {
                    return this.package.source === source;
                }
                hasPackageError(error) {
                    return this.package.error == error;
                }
                setCommand(title, command, args) {
                    this.command = {
                        title,
                        command,
                        arguments: args
                    };
                    return this;
                }
            };
            exports_51("VersionLens", VersionLens);
        }
    };
});
System.register("presentation/extension/commands/suggestionCommands", ["core/packages", "presentation/extension"], function (exports_52, context_52) {
    "use strict";
    var packages_2, extension_2, SuggestionCommandContributions, SuggestionCommands;
    var __moduleName = context_52 && context_52.id;
    function registerSuggestionCommands(extension, logger) {
        const suggestionCommands = new SuggestionCommands(extension, logger);
        return extension_2.CommandHelpers.registerCommands(SuggestionCommandContributions, suggestionCommands, logger);
    }
    exports_52("registerSuggestionCommands", registerSuggestionCommands);
    return {
        setters: [
            function (packages_2_1) {
                packages_2 = packages_2_1;
            },
            function (extension_2_1) {
                extension_2 = extension_2_1;
            }
        ],
        execute: function () {
            (function (SuggestionCommandContributions) {
                SuggestionCommandContributions["UpdateDependencyCommand"] = "versionlens.onUpdateDependencyCommand";
                SuggestionCommandContributions["LinkCommand"] = "versionlens.onLinkCommand";
            })(SuggestionCommandContributions || (SuggestionCommandContributions = {}));
            exports_52("SuggestionCommandContributions", SuggestionCommandContributions);
            SuggestionCommands = class SuggestionCommands {
                constructor(extension, logger) {
                    this.extension = extension;
                    this.state = extension.state;
                    this.logger = logger;
                }
                onUpdateDependencyCommand(codeLens, packageVersion) {
                    if (codeLens.__replaced)
                        return Promise.resolve();
                    const { workspace, WorkspaceEdit } = require('vscode');
                    const edit = new WorkspaceEdit();
                    edit.replace(codeLens.documentUrl, codeLens.replaceRange, packageVersion);
                    return workspace.applyEdit(edit)
                        .then(done => codeLens.__replaced = true);
                }
                onLinkCommand(codeLens) {
                    const path = require('path');
                    if (codeLens.package.source !== packages_2.PackageSourceTypes.Directory) {
                        this.logger.error("onLinkCommand can only open local directories.\nPackage: %o", codeLens.package);
                        return;
                    }
                    const { env } = require('vscode');
                    const filePathToOpen = path.resolve(path.dirname(codeLens.documentUrl.fsPath), codeLens.package.resolved.version);
                    env.openExternal('file:///' + filePathToOpen);
                }
            };
            exports_52("SuggestionCommands", SuggestionCommands);
        }
    };
});
System.register("presentation/extension/events/textEditorEvents", ["presentation/providers"], function (exports_53, context_53) {
    "use strict";
    var providers_1, providers_2, TextEditorEvents, _singleton;
    var __moduleName = context_53 && context_53.id;
    function registerTextEditorEvents(extensionState, extLogger) {
        _singleton = new TextEditorEvents(extensionState, extLogger);
        return _singleton;
    }
    exports_53("registerTextEditorEvents", registerTextEditorEvents);
    return {
        setters: [
            function (providers_1_1) {
                providers_1 = providers_1_1;
                providers_2 = providers_1_1;
            }
        ],
        execute: function () {
            TextEditorEvents = class TextEditorEvents {
                constructor(extensionState, logger) {
                    this.state = extensionState;
                    this.logger = logger;
                    // register editor events
                    const { window } = require('vscode');
                    window.onDidChangeActiveTextEditor(this.onDidChangeActiveTextEditor.bind(this));
                }
                onDidChangeActiveTextEditor(textEditor) {
                    // maintain versionLens.providerActive state
                    // each time the active editor changes
                    if (!textEditor) {
                        // disable icons when no editor
                        this.state.providerActive.value = false;
                        return;
                    }
                    if (textEditor.document.uri.scheme !== 'file')
                        return;
                    const providersMatchingFilename = providers_1.providerRegistry.getByFileName(textEditor.document.fileName);
                    if (providersMatchingFilename.length === 0) {
                        // disable icons if no match found
                        this.state.providerActive.value = false;
                        return;
                    }
                    // determine prerelease support
                    const providerSupportsPrereleases = providersMatchingFilename.reduce((v, p) => p.config.options.supports.includes(providers_2.ProviderSupport.Prereleases), false);
                    // determine installed statuses support
                    const providerSupportsInstalledStatuses = providersMatchingFilename.reduce((v, p) => p.config.options.supports.includes(providers_2.ProviderSupport.InstalledStatuses), false);
                    this.state.providerSupportsPrereleases.value = providerSupportsPrereleases;
                    this.state.providerSupportsInstalledStatuses.value = providerSupportsInstalledStatuses;
                    this.state.providerActive.value = true;
                }
            };
            exports_53("TextEditorEvents", TextEditorEvents);
            _singleton = null;
            exports_53("default", _singleton);
        }
    };
});
System.register("presentation/extension/helpers/installedStatusHelpers", [], function (exports_54, context_54) {
    "use strict";
    var window, _decorations, _decorationTypeKey;
    var __moduleName = context_54 && context_54.id;
    function clearDecorations() {
        const { window } = require('vscode');
        if (!window || !window.activeTextEditor)
            return;
        _decorations = [];
        window.activeTextEditor.setDecorations(_decorationTypeKey, []);
    }
    exports_54("clearDecorations", clearDecorations);
    function setDecorations(decorationList) {
        const { window } = require('vscode');
        if (!window || !window.activeTextEditor)
            return;
        window.activeTextEditor.setDecorations(_decorationTypeKey, decorationList);
    }
    exports_54("setDecorations", setDecorations);
    function removeDecorations(removeDecorationList) {
        if (removeDecorationList.length === 0 || _decorations.length === 0)
            return;
        const newDecorations = [];
        for (let i = 0; i < _decorations.length; i++) {
            const foundIndex = removeDecorationList.indexOf(_decorations[i]);
            if (foundIndex === -1)
                newDecorations.push(_decorations[i]);
        }
        _decorations = newDecorations;
        window.activeTextEditor.setDecorations(_decorationTypeKey, _decorations);
    }
    exports_54("removeDecorations", removeDecorations);
    function removeDecorationsFromLine(lineNum) {
        const results = [];
        for (let i = 0; i < _decorations.length; i++) {
            const entry = _decorations[i];
            if (entry.range.start.line >= lineNum) {
                results.push(entry);
            }
        }
        removeDecorations(results);
    }
    exports_54("removeDecorationsFromLine", removeDecorationsFromLine);
    function getDecorationsByLine(lineToFilterBy) {
        const results = [];
        for (let i = 0; i < _decorations.length; i++) {
            const entry = _decorations[i];
            if (entry.range.start.line === lineToFilterBy) {
                results.push(entry);
            }
        }
        return results;
    }
    exports_54("getDecorationsByLine", getDecorationsByLine);
    function createRenderOptions(contentText, color) {
        return {
            contentText,
            color
        };
    }
    exports_54("createRenderOptions", createRenderOptions);
    function renderMissingDecoration(range, missingStatusColour) {
        const { Range, Position } = require('vscode');
        updateDecoration({
            range: new Range(range.start, new Position(range.end.line, range.end.character + 1)),
            hoverMessage: null,
            renderOptions: {
                after: createRenderOptions(' ▪ missing install', missingStatusColour)
            }
        });
    }
    exports_54("renderMissingDecoration", renderMissingDecoration);
    function renderInstalledDecoration(range, version, installedStatusColour) {
        const { Range, Position } = require('vscode');
        updateDecoration({
            range: new Range(range.start, new Position(range.end.line, range.end.character + 1)),
            hoverMessage: null,
            renderOptions: {
                after: createRenderOptions(` ▪ ${version} installed`, installedStatusColour)
            }
        });
    }
    exports_54("renderInstalledDecoration", renderInstalledDecoration);
    function renderNeedsUpdateDecoration(range, version, outdatedStatusColour) {
        const { Range, Position } = require('vscode');
        updateDecoration({
            range: new Range(range.start, new Position(range.end.line, range.end.character + 1)),
            hoverMessage: null,
            renderOptions: {
                after: createRenderOptions(` ▪ ${version} installed, npm update needed`, outdatedStatusColour)
            }
        });
    }
    exports_54("renderNeedsUpdateDecoration", renderNeedsUpdateDecoration);
    function renderOutdatedDecoration(range, version, outdatedStatusColour) {
        const { Range, Position } = require('vscode');
        updateDecoration({
            range: new Range(range.start, new Position(range.end.line, range.end.character + 1)),
            hoverMessage: null,
            renderOptions: {
                after: createRenderOptions(` ▪ ${version} installed`, outdatedStatusColour)
            }
        });
    }
    exports_54("renderOutdatedDecoration", renderOutdatedDecoration);
    function renderPrereleaseInstalledDecoration(range, version, prereleaseInstalledStatusColour) {
        const { Range, Position } = require('vscode');
        updateDecoration({
            range: new Range(range.start, new Position(range.end.line, range.end.character + 1)),
            hoverMessage: null,
            renderOptions: {
                after: createRenderOptions(` ▪ ${version} prerelease installed`, prereleaseInstalledStatusColour)
            }
        });
    }
    exports_54("renderPrereleaseInstalledDecoration", renderPrereleaseInstalledDecoration);
    function updateDecoration(newDecoration) {
        const foundIndex = _decorations.findIndex(entry => entry.range.start.line === newDecoration.range.start.line);
        if (foundIndex > -1)
            _decorations[foundIndex] = newDecoration;
        else
            _decorations.push(newDecoration);
        setDecorations(_decorations);
    }
    return {
        setters: [],
        execute: function () {
            window = require('vscode').window;
            _decorations = [];
            _decorationTypeKey = window.createTextEditorDecorationType({
                margin: '0 .2em 0 0'
            });
        }
    };
});
System.register("presentation/extension/events/textDocumentEvents", ["presentation/extension/helpers/installedStatusHelpers"], function (exports_55, context_55) {
    "use strict";
    var InstalledStatusHelpers, TextDocumentEvents, _singleton;
    var __moduleName = context_55 && context_55.id;
    function registerTextDocumentEvents(extensionState, extLogger) {
        _singleton = new TextDocumentEvents(extensionState, extLogger);
        return _singleton;
    }
    exports_55("registerTextDocumentEvents", registerTextDocumentEvents);
    return {
        setters: [
            function (InstalledStatusHelpers_1) {
                InstalledStatusHelpers = InstalledStatusHelpers_1;
            }
        ],
        execute: function () {
            TextDocumentEvents = class TextDocumentEvents {
                constructor(extensionState, logger) {
                    this.state = extensionState;
                    this.logger = logger;
                    // register editor events
                    const { workspace } = require('vscode');
                    // register window and workspace events
                    workspace.onDidChangeTextDocument(this.onDidChangeTextDocument.bind(this));
                }
                onDidChangeTextDocument(changeEvent) {
                    // ensure version lens is active
                    if (this.state.providerActive.value === false)
                        return;
                    const foundDecorations = [];
                    const { contentChanges } = changeEvent;
                    // get all decorations for all the lines that have changed
                    contentChanges.forEach(change => {
                        const startLine = change.range.start.line;
                        let endLine = change.range.end.line;
                        if (change.text.charAt(0) == '\n' || endLine > startLine) {
                            InstalledStatusHelpers.removeDecorationsFromLine(startLine);
                            return;
                        }
                        for (let line = startLine; line <= endLine; line++) {
                            const lineDecorations = InstalledStatusHelpers.getDecorationsByLine(line);
                            if (lineDecorations.length > 0)
                                foundDecorations.push(...lineDecorations);
                        }
                    });
                    if (foundDecorations.length === 0)
                        return;
                    // remove all decorations that have changed
                    InstalledStatusHelpers.removeDecorations(foundDecorations);
                }
            };
            exports_55("TextDocumentEvents", TextDocumentEvents);
            _singleton = null;
            exports_55("default", _singleton);
        }
    };
});
System.register("presentation/extension/helpers/commandHelpers", [], function (exports_56, context_56) {
    "use strict";
    var __moduleName = context_56 && context_56.id;
    function registerCommands(contributions, handlers, logger) {
        const { commands } = require('vscode');
        const disposables = [];
        // loop enum keys
        Object.keys(contributions)
            .forEach(enumKey => {
            // register command
            const command = contributions[enumKey];
            const handler = handlers[`on${enumKey}`];
            if (!handler) {
                // todo roll up errors to a semantic factory
                const msg = `Could not find %s handler on %s class`;
                logger.error(msg, command, handler.name);
                // just return here?
                throw new Error(`Could not find ${command} handler on ${handler.name} class`);
            }
            // collect disposables
            disposables.push(commands.registerCommand(command, handler.bind(handlers)));
        });
        return disposables;
    }
    exports_56("registerCommands", registerCommands);
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("presentation/extension/commands/iconCommands", ["presentation/providers", "presentation/extension", "presentation/extension/helpers/installedStatusHelpers"], function (exports_57, context_57) {
    "use strict";
    var providers_3, extension_3, InstalledStatusHelpers, IconCommandContributions, IconCommands;
    var __moduleName = context_57 && context_57.id;
    function registerIconCommands(extension, logger) {
        const iconCommands = new IconCommands(extension);
        return extension_3.CommandHelpers.registerCommands(IconCommandContributions, iconCommands, logger);
    }
    exports_57("registerIconCommands", registerIconCommands);
    return {
        setters: [
            function (providers_3_1) {
                providers_3 = providers_3_1;
            },
            function (extension_3_1) {
                extension_3 = extension_3_1;
            },
            function (InstalledStatusHelpers_2) {
                InstalledStatusHelpers = InstalledStatusHelpers_2;
            }
        ],
        execute: function () {
            (function (IconCommandContributions) {
                IconCommandContributions["ShowError"] = "versionlens.onShowError";
                IconCommandContributions["ShowingProgress"] = "versionlens.onShowingProgress";
                IconCommandContributions["ShowInstalledStatuses"] = "versionlens.onShowInstalledStatuses";
                IconCommandContributions["HideInstalledStatuses"] = "versionlens.onHideInstalledStatuses";
                IconCommandContributions["ShowPrereleaseVersions"] = "versionlens.onShowPrereleaseVersions";
                IconCommandContributions["HidePrereleaseVersions"] = "versionlens.onHidePrereleaseVersions";
                IconCommandContributions["ShowVersionLenses"] = "versionlens.onShowVersionLenses";
                IconCommandContributions["HideVersionLenses"] = "versionlens.onHideVersionLenses";
            })(IconCommandContributions || (IconCommandContributions = {}));
            exports_57("IconCommandContributions", IconCommandContributions);
            IconCommands = class IconCommands {
                constructor(extension) {
                    this.extension = extension;
                    this.state = extension.state;
                }
                onShowError(resourceUri) {
                    return Promise.all([
                        this.state.providerError.change(false),
                        this.state.providerBusy.change(0)
                    ])
                        .then(_ => {
                        this.extension.outputChannel.show();
                    });
                }
                onShowVersionLenses(resourceUri) {
                    this.state.enabled.change(true)
                        .then(_ => {
                        providers_3.providerRegistry.refreshActiveCodeLenses();
                    });
                }
                onHideVersionLenses(resourceUri) {
                    this.state.enabled.change(false)
                        .then(_ => {
                        providers_3.providerRegistry.refreshActiveCodeLenses();
                    });
                }
                onShowPrereleaseVersions(resourceUri) {
                    this.state.prereleasesEnabled.change(true)
                        .then(_ => {
                        providers_3.providerRegistry.refreshActiveCodeLenses();
                    });
                }
                onHidePrereleaseVersions(resourceUri) {
                    this.state.prereleasesEnabled.change(false)
                        .then(_ => {
                        providers_3.providerRegistry.refreshActiveCodeLenses();
                    });
                }
                onShowInstalledStatuses(resourceUri) {
                    this.state.installedStatusesEnabled.change(true)
                        .then(_ => {
                        providers_3.providerRegistry.refreshActiveCodeLenses();
                    });
                }
                onHideInstalledStatuses(resourceUri) {
                    this.state.installedStatusesEnabled.change(false)
                        .then(_ => {
                        InstalledStatusHelpers.clearDecorations();
                    });
                }
                onShowingProgress(resourceUri) { }
            };
            exports_57("IconCommands", IconCommands);
        }
    };
});
System.register("presentation/extension", ["presentation/extension/versionLensExtension", "presentation/extension/commands/suggestionCommands", "presentation/extension/versionLensState", "presentation/extension/events/textEditorEvents", "presentation/extension/events/textDocumentEvents", "presentation/extension/models/contextState", "presentation/extension/helpers/installedStatusHelpers", "presentation/extension/helpers/commandHelpers", "presentation/extension/commands/iconCommands"], function (exports_58, context_58) {
    "use strict";
    var __moduleName = context_58 && context_58.id;
    var exportedNames_3 = {
        "CommandHelpers": true
    };
    function exportStar_8(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default" && !exportedNames_3.hasOwnProperty(n)) exports[n] = m[n];
        }
        exports_58(exports);
    }
    return {
        setters: [
            function (versionLensExtension_1_1) {
                exportStar_8(versionLensExtension_1_1);
            },
            function (suggestionCommands_1_1) {
                exportStar_8(suggestionCommands_1_1);
            },
            function (versionLensState_1_1) {
                exportStar_8(versionLensState_1_1);
            },
            function (textEditorEvents_1_1) {
                exportStar_8(textEditorEvents_1_1);
            },
            function (textDocumentEvents_1_1) {
                exportStar_8(textDocumentEvents_1_1);
            },
            function (contextState_2_1) {
                exportStar_8(contextState_2_1);
            },
            function (installedStatusHelpers_1_1) {
                exportStar_8(installedStatusHelpers_1_1);
            },
            function (CommandHelpers_1) {
                exports_58("CommandHelpers", CommandHelpers_1);
            },
            function (iconCommands_1_1) {
                exportStar_8(iconCommands_1_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("presentation/providers/definitions/iProviderOptions", [], function (exports_59, context_59) {
    "use strict";
    var ProviderSupport;
    var __moduleName = context_59 && context_59.id;
    return {
        setters: [],
        execute: function () {
            (function (ProviderSupport) {
                ProviderSupport["Releases"] = "releases";
                ProviderSupport["Prereleases"] = "prereleases";
                ProviderSupport["InstalledStatuses"] = "installedStatuses";
            })(ProviderSupport || (ProviderSupport = {}));
            exports_59("ProviderSupport", ProviderSupport);
        }
    };
});
System.register("presentation/providers/definitions/iProviderConfig", [], function (exports_60, context_60) {
    "use strict";
    var __moduleName = context_60 && context_60.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("presentation/providers/providerRegistry", [], function (exports_61, context_61) {
    "use strict";
    var ProviderRegistry, providerRegistry;
    var __moduleName = context_61 && context_61.id;
    async function registerProviders(extension, appLogger) {
        const { languages: { registerCodeLensProvider } } = require('vscode');
        const providerNames = providerRegistry.providerNames;
        appLogger.debug('Registering providers %o', providerNames.join(', '));
        const promisedActivation = providerNames.map(packageManager => {
            return context_61.import(`infrastructure/providers/${packageManager}/activate`).then(module => {
                appLogger.debug('Activating package manager %s', packageManager);
                const provider = module.activate(extension, appLogger.child({ namespace: packageManager }));
                appLogger.debug('Activated package provider for %s:\n file pattern: %s\n caching: %s minutes\n strict ssl: %s\n', packageManager, provider.config.options.selector.pattern, provider.config.caching.duration, provider.config.http.strictSSL);
                return providerRegistry.register(provider);
            })
                .then(provider => {
                return registerCodeLensProvider(provider.config.options.selector, provider);
            })
                .catch(error => {
                appLogger.error('Could not register package manager %s. Reason: %O', packageManager, error);
            });
        });
        return Promise.all(promisedActivation);
    }
    exports_61("registerProviders", registerProviders);
    function matchesFilename(filename, pattern) {
        const minimatch = require('minimatch');
        return minimatch(filename, pattern);
    }
    return {
        setters: [],
        execute: function () {
            ProviderRegistry = class ProviderRegistry {
                constructor() {
                    this.providers = {};
                    this.providerNames = [
                        'composer',
                        'dotnet',
                        'dub',
                        'jspm',
                        'maven',
                        'npm',
                        'pub',
                    ];
                }
                register(provider) {
                    const key = provider.config.options.providerName;
                    if (this.has(key))
                        throw new Error('Provider already registered');
                    this.providers[key] = provider;
                    return provider;
                }
                get(key) {
                    return this.providers[key];
                }
                has(key) {
                    return !!this.providers[key];
                }
                getByFileName(fileName) {
                    const path = require('path');
                    const filename = path.basename(fileName);
                    const filtered = this.providerNames
                        .map(name => this.providers[name])
                        .filter(provider => matchesFilename(filename, provider.config.options.selector.pattern));
                    if (filtered.length === 0)
                        return [];
                    return filtered;
                }
                refreshActiveCodeLenses() {
                    const { window } = require('vscode');
                    const fileName = window.activeTextEditor.document.fileName;
                    const providers = this.getByFileName(fileName);
                    if (!providers)
                        return false;
                    providers.forEach(provider => provider.refreshCodeLenses());
                    return true;
                }
            };
            exports_61("providerRegistry", providerRegistry = new ProviderRegistry());
        }
    };
});
System.register("presentation/lenses/commands/suggestionCommandFactory", ["core/packages", "presentation/extension"], function (exports_62, context_62) {
    "use strict";
    var packages_3, extension_4, extension_5;
    var __moduleName = context_62 && context_62.id;
    function createErrorCommand(errorMsg, codeLens) {
        return codeLens.setCommand(`${errorMsg}`);
    }
    exports_62("createErrorCommand", createErrorCommand);
    function createTagCommand(tag, codeLens) {
        return codeLens.setCommand(tag);
    }
    exports_62("createTagCommand", createTagCommand);
    function createDirectoryLinkCommand(codeLens) {
        let title;
        let cmd = extension_5.SuggestionCommandContributions.LinkCommand;
        const path = require('path');
        const fs = require('fs');
        const filePath = path.resolve(path.dirname(codeLens.documentUrl.fsPath), codeLens.package.suggestion.version);
        const fileExists = fs.existsSync(filePath);
        if (fileExists === false)
            title = (cmd = null) || 'Specified resource does not exist';
        else
            title = `${extension_4.SuggestionIndicators.OpenNewWindow} ${codeLens.package.requested.version}`;
        return codeLens.setCommand(title, cmd, [codeLens]);
    }
    exports_62("createDirectoryLinkCommand", createDirectoryLinkCommand);
    function createSuggestedVersionCommand(codeLens) {
        const { name, version, flags } = codeLens.package.suggestion;
        const isStatus = (flags & packages_3.PackageSuggestionFlags.status);
        const isTag = (flags & packages_3.PackageSuggestionFlags.tag);
        const isPrerelease = flags & packages_3.PackageSuggestionFlags.prerelease;
        if (!isStatus) {
            const replaceWithVersion = isPrerelease || isTag ?
                version :
                codeLens.replaceVersionFn(codeLens.package, version);
            const prefix = isTag ? '' : name + ': ';
            return codeLens.setCommand(`${prefix}${extension_4.SuggestionIndicators.Update} ${version}`, extension_5.SuggestionCommandContributions.UpdateDependencyCommand, [codeLens, `${replaceWithVersion}`]);
        }
        // show the status
        return createTagCommand(`${name} ${version}`.trimEnd(), codeLens);
    }
    exports_62("createSuggestedVersionCommand", createSuggestedVersionCommand);
    function createPackageNotFoundCommand(codeLens) {
        return createErrorCommand(`${codeLens.package.requested.name} could not be found`, codeLens);
    }
    exports_62("createPackageNotFoundCommand", createPackageNotFoundCommand);
    function createPackageUnexpectedError(codeLens) {
        // An error occurred retrieving this package.
        return createErrorCommand(`Unexpected error. See dev tools console`, codeLens);
    }
    exports_62("createPackageUnexpectedError", createPackageUnexpectedError);
    function createPackageMessageCommand(codeLens) {
        return createErrorCommand(`${codeLens.package.meta.message}`, codeLens);
    }
    exports_62("createPackageMessageCommand", createPackageMessageCommand);
    return {
        setters: [
            function (packages_3_1) {
                packages_3 = packages_3_1;
            },
            function (extension_4_1) {
                extension_4 = extension_4_1;
                extension_5 = extension_4_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("presentation/lenses/versionLensFactory", ["presentation/lenses/versionLens"], function (exports_63, context_63) {
    "use strict";
    var versionLens_1;
    var __moduleName = context_63 && context_63.id;
    function createFromPackageResponses(document, responses, replaceVersionFn) {
        return responses.map(function (response) {
            return createFromPackageResponse(response, document, replaceVersionFn);
        });
    }
    exports_63("createFromPackageResponses", createFromPackageResponses);
    function createFromPackageResponse(packageResponse, document, replaceVersionFn) {
        const { Uri, Range } = require('vscode');
        const { nameRange, versionRange } = packageResponse;
        const commandRangePos = nameRange.start + packageResponse.order;
        const commandRange = new Range(document.positionAt(commandRangePos), document.positionAt(commandRangePos));
        const replaceRange = new Range(document.positionAt(versionRange.start), document.positionAt(versionRange.end));
        return new versionLens_1.VersionLens(commandRange, replaceRange, packageResponse, Uri.file(document.fileName), replaceVersionFn);
    }
    return {
        setters: [
            function (versionLens_1_1) {
                versionLens_1 = versionLens_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("presentation/lenses", ["presentation/lenses/definitions/iVersionCodeLens", "presentation/lenses/commands/suggestionCommandFactory", "presentation/lenses/versionLensFactory", "presentation/lenses/versionLens"], function (exports_64, context_64) {
    "use strict";
    var __moduleName = context_64 && context_64.id;
    var exportedNames_4 = {
        "CommandFactory": true,
        "VersionLensFactory": true
    };
    function exportStar_9(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default" && !exportedNames_4.hasOwnProperty(n)) exports[n] = m[n];
        }
        exports_64(exports);
    }
    return {
        setters: [
            function (iVersionCodeLens_1_1) {
                exportStar_9(iVersionCodeLens_1_1);
            },
            function (CommandFactory_1) {
                exports_64("CommandFactory", CommandFactory_1);
            },
            function (VersionLensFactory_1) {
                exports_64("VersionLensFactory", VersionLensFactory_1);
            },
            function (versionLens_2_1) {
                exportStar_9(versionLens_2_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("presentation/providers/providerUtils", ["core/packages"], function (exports_65, context_65) {
    "use strict";
    var packages_4;
    var __moduleName = context_65 && context_65.id;
    function defaultReplaceFn(packageResponse, newVersion) {
        return packages_4.VersionHelpers.formatWithExistingLeading(packageResponse.requested.version, newVersion);
    }
    exports_65("defaultReplaceFn", defaultReplaceFn);
    return {
        setters: [
            function (packages_4_1) {
                packages_4 = packages_4_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("presentation/providers/abstractProvider", ["core/packages", "presentation/lenses", "presentation/providers/providerUtils"], function (exports_66, context_66) {
    "use strict";
    var packages_5, lenses_1, providerUtils_1, AbstractVersionLensProvider;
    var __moduleName = context_66 && context_66.id;
    return {
        setters: [
            function (packages_5_1) {
                packages_5 = packages_5_1;
            },
            function (lenses_1_1) {
                lenses_1 = lenses_1_1;
            },
            function (providerUtils_1_1) {
                providerUtils_1 = providerUtils_1_1;
            }
        ],
        execute: function () {
            AbstractVersionLensProvider = class AbstractVersionLensProvider {
                constructor(config, logger) {
                    const { EventEmitter } = require('vscode');
                    this.config = config;
                    this._onChangeCodeLensesEmitter = new EventEmitter();
                    this.onDidChangeCodeLenses = this._onChangeCodeLensesEmitter.event;
                    this.logger = logger;
                    this.extension = config.extension;
                }
                refreshCodeLenses() {
                    this._onChangeCodeLensesEmitter.fire();
                }
                async provideCodeLenses(document, token) {
                    if (this.extension.state.enabled.value === false)
                        return null;
                    // package path
                    const { dirname } = require('path');
                    const packagePath = dirname(document.uri.fsPath);
                    // clear any errors
                    this.extension.state.providerError.value = false;
                    // set in progress
                    this.extension.state.providerBusy.value++;
                    this.logger.info("Analysing dependencies for %s", document.uri.fsPath);
                    // unfreeze config per file request
                    this.config.caching.defrost();
                    this.logger.debug("Caching duration is set to %s milliseconds", this.config.caching.duration);
                    return this.fetchVersionLenses(packagePath, document, token)
                        .then(responses => {
                        this.extension.state.providerBusy.value--;
                        if (responses === null) {
                            this.logger.info("No dependencies found in %s", document.uri.fsPath);
                            return null;
                        }
                        this.logger.info("Resolved %s dependencies", responses.length);
                        return lenses_1.VersionLensFactory.createFromPackageResponses(document, responses, this.customReplaceFn || providerUtils_1.defaultReplaceFn);
                    })
                        .catch(error => {
                        this.extension.state.providerError.value = true;
                        this.extension.state.providerBusy.change(0);
                        return Promise.reject(error);
                    });
                }
                async resolveCodeLens(codeLens, token) {
                    if (codeLens instanceof lenses_1.VersionLens) {
                        // evaluate the code lens
                        const evaluated = this.evaluateCodeLens(codeLens, token);
                        // update the progress
                        return Promise.resolve(evaluated);
                    }
                }
                evaluateCodeLens(codeLens, token) {
                    if (codeLens.hasPackageError(packages_5.PackageResponseErrors.Unexpected))
                        return lenses_1.CommandFactory.createPackageUnexpectedError(codeLens);
                    if (codeLens.hasPackageError(packages_5.PackageResponseErrors.NotFound))
                        return lenses_1.CommandFactory.createPackageNotFoundCommand(codeLens);
                    if (codeLens.hasPackageError(packages_5.PackageResponseErrors.NotSupported))
                        return lenses_1.CommandFactory.createPackageMessageCommand(codeLens);
                    if (codeLens.hasPackageError(packages_5.PackageResponseErrors.GitNotFound))
                        return lenses_1.CommandFactory.createPackageMessageCommand(codeLens);
                    if (codeLens.hasPackageSource(packages_5.PackageSourceTypes.Directory))
                        return lenses_1.CommandFactory.createDirectoryLinkCommand(codeLens);
                    return lenses_1.CommandFactory.createSuggestedVersionCommand(codeLens);
                }
            };
            exports_66("AbstractVersionLensProvider", AbstractVersionLensProvider);
        }
    };
});
System.register("presentation/providers/abstractProviderConfig", [], function (exports_67, context_67) {
    "use strict";
    var AbstractProviderConfig;
    var __moduleName = context_67 && context_67.id;
    return {
        setters: [],
        execute: function () {
            AbstractProviderConfig = class AbstractProviderConfig {
                constructor(extension) {
                    this.extension = extension;
                }
            };
            exports_67("AbstractProviderConfig", AbstractProviderConfig);
        }
    };
});
System.register("presentation/providers", ["presentation/providers/definitions/iProviderConfig", "presentation/providers/definitions/iProviderOptions", "presentation/providers/providerRegistry", "presentation/providers/abstractProvider", "presentation/providers/abstractProviderConfig", "presentation/providers/providerUtils"], function (exports_68, context_68) {
    "use strict";
    var __moduleName = context_68 && context_68.id;
    function exportStar_10(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default") exports[n] = m[n];
        }
        exports_68(exports);
    }
    return {
        setters: [
            function (iProviderConfig_1_1) {
                exportStar_10(iProviderConfig_1_1);
            },
            function (iProviderOptions_1_1) {
                exportStar_10(iProviderOptions_1_1);
            },
            function (providerRegistry_1_1) {
                exportStar_10(providerRegistry_1_1);
            },
            function (abstractProvider_1_1) {
                exportStar_10(abstractProvider_1_1);
            },
            function (abstractProviderConfig_1_1) {
                exportStar_10(abstractProviderConfig_1_1);
            },
            function (providerUtils_2_1) {
                exportStar_10(providerUtils_2_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("root", ["infrastructure/configuration", "infrastructure/logging", "presentation/providers", "presentation/extension"], function (exports_69, context_69) {
    "use strict";
    var configuration_5, logging_2, providers_4, extension_6, version;
    var __moduleName = context_69 && context_69.id;
    async function composition(context) {
        const configuration = new configuration_5.VsCodeConfig(extension_6.VersionLensExtension.extensionName.toLowerCase());
        // create the output channel
        const { window } = require('vscode');
        const channel = window.createOutputChannel(extension_6.VersionLensExtension.extensionName);
        const extension = extension_6.registerExtension(configuration, channel);
        // Setup the logger
        const logger = logging_2.createWinstonLogger(channel, extension.logging);
        const appLogger = logger.child({ namespace: 'extension' });
        appLogger.info('version: %s', version);
        appLogger.info('log level: %s', extension.logging.level);
        appLogger.info('log path: %s', context.logPath);
        extension_6.registerTextDocumentEvents(extension.state, appLogger);
        const textEditorEvents = extension_6.registerTextEditorEvents(extension.state, appLogger);
        // subscribe command and providers
        const disposables = [
            ...await providers_4.registerProviders(extension, appLogger),
            ...extension_6.registerIconCommands(extension, appLogger),
            ...extension_6.registerSuggestionCommands(extension, appLogger)
        ];
        context.subscriptions.push(disposables);
        // show icons in active text editor if versionLens.providerActive
        textEditorEvents.onDidChangeActiveTextEditor(window.activeTextEditor);
    }
    exports_69("composition", composition);
    return {
        setters: [
            function (configuration_5_1) {
                configuration_5 = configuration_5_1;
            },
            function (logging_2_1) {
                logging_2 = logging_2_1;
            },
            function (providers_4_1) {
                providers_4 = providers_4_1;
            },
            function (extension_6_1) {
                extension_6 = extension_6_1;
            }
        ],
        execute: function () {
            version = require('../package.json').version;
        }
    };
});
System.register("infrastructure/providers/composer/composerConfig", ["core/clients", "presentation/providers"], function (exports_70, context_70) {
    "use strict";
    var clients_3, providers_5, ComposerContributions, ComposerConfig;
    var __moduleName = context_70 && context_70.id;
    return {
        setters: [
            function (clients_3_1) {
                clients_3 = clients_3_1;
            },
            function (providers_5_1) {
                providers_5 = providers_5_1;
            }
        ],
        execute: function () {
            (function (ComposerContributions) {
                ComposerContributions["Caching"] = "composer.caching";
                ComposerContributions["Http"] = "composer.http";
                ComposerContributions["DependencyProperties"] = "composer.dependencyProperties";
                ComposerContributions["ApiUrl"] = "composer.apiUrl";
            })(ComposerContributions || (ComposerContributions = {}));
            ComposerConfig = class ComposerConfig extends providers_5.AbstractProviderConfig {
                constructor(extension) {
                    super(extension);
                    this.options = {
                        providerName: 'composer',
                        supports: [
                            providers_5.ProviderSupport.Releases,
                            providers_5.ProviderSupport.Prereleases,
                            providers_5.ProviderSupport.InstalledStatuses,
                        ],
                        selector: {
                            language: 'json',
                            scheme: 'file',
                            pattern: '**/composer.json',
                        }
                    };
                    this.caching = new clients_3.CachingOptions(extension.config, ComposerContributions.Caching, 'caching');
                    this.http = new clients_3.HttpOptions(extension.config, ComposerContributions.Http, 'http');
                }
                get dependencyProperties() {
                    return this.extension.config.get(ComposerContributions.DependencyProperties);
                }
                get apiUrl() {
                    return this.extension.config.get(ComposerContributions.ApiUrl);
                }
            };
            exports_70("ComposerConfig", ComposerConfig);
        }
    };
});
System.register("infrastructure/clients/definitions/responses", [], function (exports_71, context_71) {
    "use strict";
    var __moduleName = context_71 && context_71.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/clients/httpClientRequest", ["core/clients"], function (exports_72, context_72) {
    "use strict";
    var clients_4, HttpClientRequest;
    var __moduleName = context_72 && context_72.id;
    return {
        setters: [
            function (clients_4_1) {
                clients_4 = clients_4_1;
            }
        ],
        execute: function () {
            HttpClientRequest = class HttpClientRequest extends clients_4.AbstractClientRequest {
                constructor(logger, options, headers) {
                    super(options.caching);
                    this.logger = logger;
                    this.options = options;
                    this.headers = headers || {};
                }
                async request(method, baseUrl, query = {}) {
                    const url = clients_4.UrlHelpers.createUrl(baseUrl, query);
                    const cacheKey = method + '_' + url;
                    if (this.cache.options.duration > 0 && this.cache.hasExpired(cacheKey) === false) {
                        const cachedResp = this.cache.get(cacheKey);
                        if (cachedResp.rejected)
                            return Promise.reject(cachedResp);
                        return Promise.resolve(cachedResp);
                    }
                    const requestLight = require('request-light');
                    return requestLight.xhr({
                        url,
                        type: method,
                        headers: this.headers,
                        strictSSL: this.options.http.strictSSL
                    })
                        .then((response) => {
                        return this.createCachedResponse(cacheKey, response.status, response.responseText, false);
                    })
                        .catch((response) => {
                        const result = this.createCachedResponse(cacheKey, response.status, response.responseText, true);
                        return Promise.reject(result);
                    });
                }
            };
            exports_72("HttpClientRequest", HttpClientRequest);
        }
    };
});
System.register("infrastructure/clients/jsonHttpClientRequest", ["infrastructure/clients/httpClientRequest"], function (exports_73, context_73) {
    "use strict";
    var httpClientRequest_1, JsonHttpClientRequest;
    var __moduleName = context_73 && context_73.id;
    return {
        setters: [
            function (httpClientRequest_1_1) {
                httpClientRequest_1 = httpClientRequest_1_1;
            }
        ],
        execute: function () {
            JsonHttpClientRequest = class JsonHttpClientRequest extends httpClientRequest_1.HttpClientRequest {
                constructor(logger, options, headers) {
                    super(logger, options, headers);
                }
                async requestJson(method, url, query = {}) {
                    return super.request(method, url, query)
                        .then(function (response) {
                        return {
                            source: response.source,
                            status: response.status,
                            data: JSON.parse(response.data),
                        };
                    });
                }
            };
            exports_73("JsonHttpClientRequest", JsonHttpClientRequest);
        }
    };
});
System.register("infrastructure/clients/processClientRequest", ["core/clients"], function (exports_74, context_74) {
    "use strict";
    var clients_5, ProcessClientRequest;
    var __moduleName = context_74 && context_74.id;
    return {
        setters: [
            function (clients_5_1) {
                clients_5 = clients_5_1;
            }
        ],
        execute: function () {
            ProcessClientRequest = class ProcessClientRequest extends clients_5.AbstractClientRequest {
                constructor(options, logger) {
                    super(options);
                    this.logger = logger;
                }
                async request(cmd, args, cwd) {
                    const cacheKey = `${cmd} ${args.join(' ')}`;
                    if (this.cache.options.duration > 0 && this.cache.hasExpired(cacheKey) === false) {
                        this.logger.debug('cached - %s', cacheKey);
                        const cachedResp = this.cache.get(cacheKey);
                        if (cachedResp.rejected)
                            return Promise.reject(cachedResp);
                        return Promise.resolve(cachedResp);
                    }
                    this.logger.debug('executing - %s', cacheKey);
                    const ps = require('@npmcli/promise-spawn');
                    return ps(cmd, args, { cwd, stdioString: true })
                        .then(result => {
                        return this.createCachedResponse(cacheKey, result.code, result.stdout, false, clients_5.ClientResponseSource.local);
                    }).catch(error => {
                        const result = this.createCachedResponse(cacheKey, error.code, error.message, true, clients_5.ClientResponseSource.local);
                        return Promise.reject(result);
                    });
                }
            };
            exports_74("ProcessClientRequest", ProcessClientRequest);
        }
    };
});
System.register("infrastructure/clients", ["infrastructure/clients/httpClientRequest", "infrastructure/clients/jsonHttpClientRequest", "infrastructure/clients/processClientRequest", "core/clients/options/httpOptions"], function (exports_75, context_75) {
    "use strict";
    var __moduleName = context_75 && context_75.id;
    function exportStar_11(m) {
        var exports = {};
        for (var n in m) {
            if (n !== "default") exports[n] = m[n];
        }
        exports_75(exports);
    }
    return {
        setters: [
            function (httpClientRequest_2_1) {
                exportStar_11(httpClientRequest_2_1);
            },
            function (jsonHttpClientRequest_1_1) {
                exportStar_11(jsonHttpClientRequest_1_1);
            },
            function (processClientRequest_1_1) {
                exportStar_11(processClientRequest_1_1);
            },
            function (httpOptions_2_1) {
                exportStar_11(httpOptions_2_1);
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/composer/composerClient", ["core/packages", "core/clients", "infrastructure/clients"], function (exports_76, context_76) {
    "use strict";
    var packages_6, clients_6, clients_7, ComposerClient;
    var __moduleName = context_76 && context_76.id;
    async function createRemotePackageDocument(client, url, request, semverSpec) {
        return client.requestJson(clients_6.HttpClientRequestMethods.get, url, {})
            .then(function (httpResponse) {
            const packageInfo = httpResponse.data.packages[request.package.name];
            const { providerName } = request;
            const versionRange = semverSpec.rawVersion;
            const requested = request.package;
            const resolved = {
                name: requested.name,
                version: versionRange,
            };
            const response = {
                source: httpResponse.source,
                status: httpResponse.status,
            };
            const rawVersions = Object.keys(packageInfo);
            // extract semver versions only
            const semverVersions = packages_6.VersionHelpers.filterSemverVersions(rawVersions);
            // seperate versions to releases and prereleases
            const { releases, prereleases } = packages_6.VersionHelpers.splitReleasesFromArray(packages_6.VersionHelpers.filterSemverVersions(semverVersions));
            // analyse suggestions
            const suggestions = packages_6.SuggestionFactory.createSuggestionTags(versionRange, releases, prereleases);
            return {
                providerName,
                source: packages_6.PackageSourceTypes.Registry,
                response,
                type: semverSpec.type,
                requested,
                resolved,
                suggestions,
            };
        });
    }
    function readComposerSelections(filePath) {
        return new Promise(function (resolve, reject) {
            const fs = require('fs');
            if (fs.existsSync(filePath) === false) {
                reject(null);
                return;
            }
            fs.readFile(filePath, "utf-8", (err, data) => {
                if (err) {
                    reject(err);
                    return;
                }
                const selectionsJson = JSON.parse(data.toString());
                resolve(selectionsJson);
            });
        });
    }
    exports_76("readComposerSelections", readComposerSelections);
    return {
        setters: [
            function (packages_6_1) {
                packages_6 = packages_6_1;
            },
            function (clients_6_1) {
                clients_6 = clients_6_1;
            },
            function (clients_7_1) {
                clients_7 = clients_7_1;
            }
        ],
        execute: function () {
            ComposerClient = class ComposerClient extends clients_7.JsonHttpClientRequest {
                constructor(config, options, logger) {
                    super(logger, options, {});
                    this.config = config;
                }
                async fetchPackage(request) {
                    const semverSpec = packages_6.VersionHelpers.parseSemver(request.package.version);
                    const url = `${this.config.apiUrl}/${request.package.name}.json`;
                    return createRemotePackageDocument(this, url, request, semverSpec)
                        .catch((error) => {
                        if (error.status === 404) {
                            return packages_6.DocumentFactory.createNotFound(request.providerName, request.package, null, packages_6.ResponseFactory.createResponseStatus(error.source, error.status));
                        }
                        return Promise.reject(error);
                    });
                }
            };
            exports_76("ComposerClient", ComposerClient);
        }
    };
});
System.register("infrastructure/providers/composer/composerProvider", ["core/packages", "presentation/extension", "presentation/providers", "infrastructure/providers/composer/composerClient"], function (exports_77, context_77) {
    "use strict";
    var packages_7, extension_7, providers_6, composerClient_1, ComposerVersionLensProvider;
    var __moduleName = context_77 && context_77.id;
    return {
        setters: [
            function (packages_7_1) {
                packages_7 = packages_7_1;
            },
            function (extension_7_1) {
                extension_7 = extension_7_1;
            },
            function (providers_6_1) {
                providers_6 = providers_6_1;
            },
            function (composerClient_1_1) {
                composerClient_1 = composerClient_1_1;
            }
        ],
        execute: function () {
            ComposerVersionLensProvider = class ComposerVersionLensProvider extends providers_6.AbstractVersionLensProvider {
                constructor(config, logger) {
                    super(config, logger);
                    const requestOptions = {
                        caching: config.caching,
                        http: config.http
                    };
                    this.composerClient = new composerClient_1.ComposerClient(config, requestOptions, logger.child({ namespace: 'composer pkg client' }));
                }
                async fetchVersionLenses(packagePath, document, token) {
                    const packageDependencies = packages_7.extractPackageDependenciesFromJson(document.getText(), this.config.dependencyProperties);
                    if (packageDependencies.length === 0)
                        return null;
                    const includePrereleases = this.extension.state.prereleasesEnabled.value;
                    const context = {
                        includePrereleases,
                        clientData: null,
                    };
                    return packages_7.RequestFactory.executeDependencyRequests(packagePath, this.composerClient, packageDependencies, context);
                }
                async updateOutdated(packagePath) {
                    const { join } = require('path');
                    const selectionsFilePath = join(packagePath, 'composer.lock');
                    return composerClient_1.readComposerSelections(selectionsFilePath)
                        .then((selectionsJson) => {
                        let packages = {};
                        for (let onepackage in selectionsJson.packages) {
                            packages[selectionsJson.packages[onepackage].name] = selectionsJson.packages[onepackage].version;
                        }
                        this._outdatedCache = packages;
                    })
                        .catch(err => {
                        if (err)
                            console.warn(err);
                    });
                }
                generateDecorations(versionLens) {
                    const currentPackageName = versionLens.package.requested.name;
                    const currentPackageVersion = versionLens.package.requested.version;
                    if (!versionLens.replaceRange)
                        return;
                    if (!this._outdatedCache) {
                        extension_7.renderMissingDecoration(versionLens.replaceRange, this.config.extension.statuses.notInstalledColour);
                        return;
                    }
                    const currentVersion = this._outdatedCache[currentPackageName];
                    if (!currentVersion) {
                        extension_7.renderMissingDecoration(versionLens.replaceRange, this.config.extension.statuses.notInstalledColour);
                        return;
                    }
                    if (packages_7.VersionHelpers.formatWithExistingLeading(currentPackageVersion, currentVersion) == currentPackageVersion) {
                        extension_7.renderInstalledDecoration(versionLens.replaceRange, currentPackageVersion, this.config.extension.statuses.installedColour);
                        return;
                    }
                    extension_7.renderOutdatedDecoration(versionLens.replaceRange, currentVersion, this.config.extension.statuses.outdatedColour);
                }
            };
            exports_77("ComposerVersionLensProvider", ComposerVersionLensProvider);
        }
    };
});
System.register("infrastructure/providers/composer/activate", ["infrastructure/providers/composer/composerProvider", "infrastructure/providers/composer/composerConfig"], function (exports_78, context_78) {
    "use strict";
    var composerProvider_1, composerConfig_1;
    var __moduleName = context_78 && context_78.id;
    function activate(extension, logger) {
        const config = new composerConfig_1.ComposerConfig(extension);
        return new composerProvider_1.ComposerVersionLensProvider(config, logger);
    }
    exports_78("activate", activate);
    return {
        setters: [
            function (composerProvider_1_1) {
                composerProvider_1 = composerProvider_1_1;
            },
            function (composerConfig_1_1) {
                composerConfig_1 = composerConfig_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/dotnet/options/nugetOptions", ["core/configuration"], function (exports_79, context_79) {
    "use strict";
    var configuration_6, NugetContributions, NugetOptions;
    var __moduleName = context_79 && context_79.id;
    return {
        setters: [
            function (configuration_6_1) {
                configuration_6 = configuration_6_1;
            }
        ],
        execute: function () {
            (function (NugetContributions) {
                NugetContributions["Sources"] = "sources";
            })(NugetContributions || (NugetContributions = {}));
            NugetOptions = class NugetOptions extends configuration_6.Options {
                constructor(config, section) {
                    super(config, section);
                }
                get sources() {
                    return this.get(NugetContributions.Sources);
                }
            };
            exports_79("NugetOptions", NugetOptions);
        }
    };
});
System.register("infrastructure/providers/dotnet/dotnetConfig", ["core/clients", "presentation/providers", "infrastructure/providers/dotnet/options/nugetOptions"], function (exports_80, context_80) {
    "use strict";
    var clients_8, providers_7, nugetOptions_1, DotnetContributions, DotNetConfig;
    var __moduleName = context_80 && context_80.id;
    return {
        setters: [
            function (clients_8_1) {
                clients_8 = clients_8_1;
            },
            function (providers_7_1) {
                providers_7 = providers_7_1;
            },
            function (nugetOptions_1_1) {
                nugetOptions_1 = nugetOptions_1_1;
            }
        ],
        execute: function () {
            (function (DotnetContributions) {
                DotnetContributions["Caching"] = "dotnet.caching";
                DotnetContributions["Http"] = "dotnet.http";
                DotnetContributions["Nuget"] = "dotnet.nuget";
                DotnetContributions["DependencyProperties"] = "dotnet.dependencyProperties";
                DotnetContributions["TagFilter"] = "dotnet.tagFilter";
            })(DotnetContributions || (DotnetContributions = {}));
            exports_80("DotnetContributions", DotnetContributions);
            DotNetConfig = class DotNetConfig extends providers_7.AbstractProviderConfig {
                constructor(extension) {
                    super(extension);
                    this.options = {
                        providerName: 'dotnet',
                        supports: [
                            providers_7.ProviderSupport.Releases,
                            providers_7.ProviderSupport.Prereleases,
                        ],
                        selector: {
                            language: 'xml',
                            scheme: 'file',
                            pattern: '**/*.{csproj,fsproj,targets,props}',
                        }
                    };
                    this.caching = new clients_8.CachingOptions(extension.config, DotnetContributions.Caching, 'caching');
                    this.http = new clients_8.HttpOptions(extension.config, DotnetContributions.Http, 'http');
                    this.nuget = new nugetOptions_1.NugetOptions(extension.config, DotnetContributions.Nuget);
                }
                get dependencyProperties() {
                    return this.extension.config.get(DotnetContributions.DependencyProperties);
                }
                get tagFilter() {
                    return this.extension.config.get(DotnetContributions.TagFilter);
                }
                get fallbackNugetSource() {
                    return 'https://api.nuget.org/v3/index.json';
                }
            };
            exports_80("DotNetConfig", DotNetConfig);
        }
    };
});
System.register("infrastructure/providers/dotnet/dotnetXmlParserFactory", [], function (exports_81, context_81) {
    "use strict";
    var __moduleName = context_81 && context_81.id;
    function createDependenciesFromXml(xml, includePropertyNames) {
        const xmldoc = require('xmldoc');
        let document = null;
        try {
            document = new xmldoc.XmlDocument(xml);
        }
        catch {
            document = null;
        }
        if (!document)
            return [];
        return extractPackageLensDataFromNodes(document, xml, includePropertyNames);
    }
    exports_81("createDependenciesFromXml", createDependenciesFromXml);
    function extractPackageLensDataFromNodes(topLevelNodes, xml, includePropertyNames) {
        const collector = [];
        topLevelNodes.eachChild(function (node) {
            if (node.name !== "ItemGroup")
                return;
            node.eachChild(function (itemGroupNode) {
                if (includePropertyNames.includes(itemGroupNode.name) == false)
                    return;
                const dependencyLens = createFromAttribute(itemGroupNode, xml);
                if (dependencyLens)
                    collector.push(dependencyLens);
            });
        });
        return collector;
    }
    function createFromAttribute(node, xml) {
        const nameRange = {
            start: node.startTagPosition,
            end: node.startTagPosition,
        };
        // xmldoc doesn't report attribute ranges so this gets them manually
        const versionRange = getAttributeRange(node, ' version="', xml);
        if (versionRange === null)
            return null;
        const packageInfo = {
            name: node.attr.Include || node.attr.Update,
            version: node.attr.Version,
        };
        return {
            nameRange,
            versionRange,
            packageInfo,
        };
    }
    function getAttributeRange(node, attributeName, xml) {
        const lineText = xml.substring(node.startTagPosition, node.position);
        let start = lineText.toLowerCase().indexOf(attributeName);
        if (start === -1)
            return null;
        start += attributeName.length;
        const end = lineText.indexOf('"', start);
        return {
            start: node.startTagPosition + start,
            end: node.startTagPosition + end,
        };
    }
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/dotnet/definitions/nuget", [], function (exports_82, context_82) {
    "use strict";
    var __moduleName = context_82 && context_82.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/dotnet/definitions/dotnet", [], function (exports_83, context_83) {
    "use strict";
    var __moduleName = context_83 && context_83.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/dotnet/clients/dotnetClient", ["core/clients", "infrastructure/clients"], function (exports_84, context_84) {
    "use strict";
    var clients_9, clients_10, DotNetClient, crLf;
    var __moduleName = context_84 && context_84.id;
    function parseSourcesArray(lines) {
        return lines.map(function (line) {
            const enabled = line.substring(0, 1) === 'E';
            const machineWide = line.substring(1, 2) === 'M';
            const offset = machineWide ? 3 : 2;
            const url = line.substring(offset);
            const protocol = clients_9.UrlHelpers.getProtocolFromUrl(url);
            return {
                enabled,
                machineWide,
                url,
                protocol
            };
        });
    }
    function convertFeedsToSources(feeds) {
        return feeds.map(function (url) {
            const protocol = clients_9.UrlHelpers.getProtocolFromUrl(url);
            const machineWide = (protocol === clients_9.UrlHelpers.RegistryProtocols.file);
            return {
                enabled: true,
                machineWide,
                url,
                protocol
            };
        });
    }
    return {
        setters: [
            function (clients_9_1) {
                clients_9 = clients_9_1;
            },
            function (clients_10_1) {
                clients_10 = clients_10_1;
            }
        ],
        execute: function () {
            DotNetClient = class DotNetClient extends clients_10.ProcessClientRequest {
                constructor(config, logger) {
                    super(config.caching, logger);
                    this.config = config;
                }
                async fetchSources(cwd) {
                    const promisedCli = super.request('dotnet', ['nuget', 'list', 'source', '--format', 'short'], cwd);
                    return await promisedCli.then(result => {
                        const { data } = result;
                        // reject when data contains "error"
                        if (data.indexOf("error") > -1)
                            return Promise.reject(result);
                        // check we have some data
                        if (data.length === 0 || data.indexOf('E') === -1) {
                            return [];
                        }
                        // extract sources
                        const hasCrLf = data.indexOf(crLf) > 0;
                        const splitChar = hasCrLf ? crLf : '\n';
                        let lines = data.split(splitChar);
                        // pop any blank entries
                        if (lines[lines.length - 1] === '')
                            lines.pop();
                        return parseSourcesArray(lines).filter(s => s.enabled);
                    }).then(sources => {
                        // combine the sources where feed take precedent
                        const feedSources = convertFeedsToSources(this.config.nuget.sources);
                        return [
                            ...feedSources,
                            ...sources
                        ];
                    }).catch(error => {
                        // return the fallback source for dotnet clients < 5.5
                        return [
                            {
                                enabled: true,
                                machineWide: false,
                                protocol: clients_9.UrlHelpers.RegistryProtocols.https,
                                url: this.config.fallbackNugetSource,
                            }
                        ];
                    });
                }
            };
            exports_84("DotNetClient", DotNetClient);
            crLf = '\r\n';
        }
    };
});
System.register("infrastructure/providers/dotnet/dotnetUtils", ["core/packages"], function (exports_85, context_85) {
    "use strict";
    var packages_8;
    var __moduleName = context_85 && context_85.id;
    function expandShortVersion(value) {
        if (!value ||
            value.indexOf('[') !== -1 ||
            value.indexOf('(') !== -1 ||
            value.indexOf(',') !== -1 ||
            value.indexOf(')') !== -1 ||
            value.indexOf(']') !== -1 ||
            value.indexOf('*') !== -1)
            return value;
        let dotCount = 0;
        for (let i = 0; i < value.length; i++) {
            const c = value[i];
            if (c === '.')
                dotCount++;
            else if (isNaN(parseInt(c)))
                return value;
        }
        let fmtValue = '';
        if (dotCount === 0)
            fmtValue = value + '.0.0';
        else if (dotCount === 1)
            fmtValue = value + '.0';
        else
            return value;
        return fmtValue;
    }
    exports_85("expandShortVersion", expandShortVersion);
    function parseVersionSpec(rawVersion) {
        const spec = buildVersionSpec(rawVersion);
        let version;
        let isValidVersion = false;
        let isValidRange = false;
        if (spec && !spec.hasFourSegments) {
            // convert spec to semver
            const { valid, validRange } = require('semver');
            version = convertVersionSpecToString(spec);
            isValidVersion = valid(version, packages_8.VersionHelpers.loosePrereleases);
            isValidRange = !isValidVersion && validRange(version, packages_8.VersionHelpers.loosePrereleases) !== null;
        }
        const type = isValidVersion ?
            packages_8.PackageVersionTypes.Version :
            isValidRange ? packages_8.PackageVersionTypes.Range : null;
        const resolvedVersion = spec ? version : '';
        return {
            type,
            rawVersion,
            resolvedVersion,
            spec
        };
    }
    exports_85("parseVersionSpec", parseVersionSpec);
    function buildVersionSpec(value) {
        let formattedValue = expandShortVersion(value.trim());
        if (!formattedValue)
            return null;
        // test if the version is in semver format
        const semver = require('semver');
        const parsedSemver = semver.parse(formattedValue, { includePrereleases: true });
        if (parsedSemver) {
            return {
                version: formattedValue,
                isMinInclusive: true,
                isMaxInclusive: true,
                hasFourSegments: false,
            };
        }
        try {
            // test if the version is a semver range format
            const parsedNodeRange = semver.validRange(formattedValue, { includePrereleases: true });
            if (parsedNodeRange) {
                return {
                    version: parsedNodeRange,
                    isMinInclusive: true,
                    isMaxInclusive: true,
                    hasFourSegments: false,
                };
            }
        }
        catch { }
        // fail if the string is too short
        if (formattedValue.length < 3)
            return null;
        const versionSpec = {};
        // first character must be [ or (
        const first = formattedValue[0];
        if (first === '[')
            versionSpec.isMinInclusive = true;
        else if (first === '(')
            versionSpec.isMinInclusive = false;
        else if (packages_8.VersionHelpers.isFourSegmentedVersion(formattedValue))
            return { hasFourSegments: true };
        else
            return null;
        // last character must be ] or )
        const last = formattedValue[formattedValue.length - 1];
        if (last === ']')
            versionSpec.isMaxInclusive = true;
        else if (last === ')')
            versionSpec.isMaxInclusive = false;
        // remove any [] or ()
        formattedValue = formattedValue.substr(1, formattedValue.length - 2);
        // split by comma
        const parts = formattedValue.split(',');
        // more than 2 is invalid
        if (parts.length > 2)
            return null;
        else if (parts.every(x => !x))
            // must be (,]
            return null;
        // if only one entry then use it for both min and max
        const minVersion = parts[0];
        const maxVersion = (parts.length == 2) ? parts[1] : parts[0];
        // parse the min version
        if (minVersion) {
            const parsedVersion = buildVersionSpec(minVersion);
            if (!parsedVersion)
                return null;
            versionSpec.minVersionSpec = parsedVersion;
            versionSpec.hasFourSegments = parsedVersion.hasFourSegments;
        }
        // parse the max version
        if (maxVersion) {
            const parsedVersion = buildVersionSpec(maxVersion);
            if (!parsedVersion)
                return null;
            versionSpec.maxVersionSpec = parsedVersion;
            versionSpec.hasFourSegments = parsedVersion.hasFourSegments;
        }
        return versionSpec;
    }
    exports_85("buildVersionSpec", buildVersionSpec);
    function convertVersionSpecToString(versionSpec) {
        // x.x.x cases
        if (versionSpec.version
            && versionSpec.isMinInclusive
            && versionSpec.isMaxInclusive)
            return versionSpec.version;
        // [x.x.x] cases
        if (versionSpec.minVersionSpec
            && versionSpec.maxVersionSpec
            && versionSpec.minVersionSpec.version === versionSpec.maxVersionSpec.version
            && versionSpec.isMinInclusive
            && versionSpec.isMaxInclusive)
            return versionSpec.minVersionSpec.version;
        let rangeBuilder = '';
        if (versionSpec.minVersionSpec) {
            rangeBuilder += '>';
            if (versionSpec.isMinInclusive)
                rangeBuilder += '=';
            rangeBuilder += versionSpec.minVersionSpec.version;
        }
        if (versionSpec.maxVersionSpec) {
            rangeBuilder += rangeBuilder.length > 0 ? ' ' : '';
            rangeBuilder += '<';
            if (versionSpec.isMaxInclusive)
                rangeBuilder += '=';
            rangeBuilder += versionSpec.maxVersionSpec.version;
        }
        return rangeBuilder;
    }
    return {
        setters: [
            function (packages_8_1) {
                packages_8 = packages_8_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/dotnet/clients/nugetPackageClient", ["core/packages", "core/clients", "infrastructure/clients", "infrastructure/providers/dotnet/dotnetUtils"], function (exports_86, context_86) {
    "use strict";
    var packages_9, clients_11, clients_12, dotnetUtils_js_1, NuGetPackageClient;
    var __moduleName = context_86 && context_86.id;
    async function createRemotePackageDocument(client, url, request, dotnetSpec) {
        const packageUrl = clients_11.UrlHelpers.ensureEndSlash(url) + `${request.package.name}/index.json`;
        return client.requestJson(clients_11.HttpClientRequestMethods.get, packageUrl)
            .then(function (httpResponse) {
            const { data } = httpResponse;
            const source = packages_9.PackageSourceTypes.Registry;
            const { providerName } = request;
            const requested = request.package;
            const packageInfo = data;
            const response = {
                source: httpResponse.source,
                status: httpResponse.status,
            };
            // sanitize to semver only versions
            const rawVersions = packages_9.VersionHelpers.filterSemverVersions(packageInfo.versions);
            // seperate versions to releases and prereleases
            const { releases, prereleases } = packages_9.VersionHelpers.splitReleasesFromArray(rawVersions);
            // four segment is not supported
            if (dotnetSpec.spec && dotnetSpec.spec.hasFourSegments) {
                return packages_9.DocumentFactory.createFourSegment(providerName, requested, packages_9.ResponseFactory.createResponseStatus(httpResponse.source, 404), dotnetSpec.type);
            }
            // no match if null type
            if (dotnetSpec.type === null) {
                return packages_9.DocumentFactory.createNoMatch(providerName, source, packages_9.PackageVersionTypes.Version, requested, packages_9.ResponseFactory.createResponseStatus(httpResponse.source, 404), 
                // suggest the latest release if available
                releases.length > 0 ? releases[releases.length - 1] : null);
            }
            const versionRange = dotnetSpec.resolvedVersion;
            const resolved = {
                name: requested.name,
                version: versionRange,
            };
            // analyse suggestions
            const suggestions = packages_9.SuggestionFactory.createSuggestionTags(versionRange, releases, prereleases);
            return {
                providerName,
                source,
                response,
                type: dotnetSpec.type,
                requested,
                resolved,
                suggestions,
            };
        });
    }
    return {
        setters: [
            function (packages_9_1) {
                packages_9 = packages_9_1;
            },
            function (clients_11_1) {
                clients_11 = clients_11_1;
            },
            function (clients_12_1) {
                clients_12 = clients_12_1;
            },
            function (dotnetUtils_js_1_1) {
                dotnetUtils_js_1 = dotnetUtils_js_1_1;
            }
        ],
        execute: function () {
            NuGetPackageClient = class NuGetPackageClient extends clients_12.JsonHttpClientRequest {
                constructor(config, options, logger) {
                    super(logger, options, {});
                    this.config = config;
                }
                async fetchPackage(request) {
                    const dotnetSpec = dotnetUtils_js_1.parseVersionSpec(request.package.version);
                    return this.fetchPackageRetry(request, dotnetSpec);
                }
                async fetchPackageRetry(request, dotnetSpec) {
                    const urls = request.clientData.serviceUrls;
                    const autoCompleteUrl = urls[request.attempt];
                    return createRemotePackageDocument(this, autoCompleteUrl, request, dotnetSpec)
                        .catch((error) => {
                        // increase the attempt number
                        request.attempt++;
                        // only retry if 404 and we have more urls to try
                        if (error.status === 404 && request.attempt < urls.length) {
                            // retry
                            return this.fetchPackageRetry(request, dotnetSpec);
                        }
                        if (error.status === 404) {
                            return packages_9.DocumentFactory.createNotFound(request.providerName, request.package, packages_9.PackageVersionTypes.Version, packages_9.ResponseFactory.createResponseStatus(error.source, 404));
                        }
                        // unexpected
                        return Promise.reject(error);
                    });
                }
            };
            exports_86("NuGetPackageClient", NuGetPackageClient);
        }
    };
});
System.register("infrastructure/providers/dotnet/clients/nugetResourceClient", ["core/clients", "infrastructure/clients"], function (exports_87, context_87) {
    "use strict";
    var clients_13, clients_14, NuGetResourceClient;
    var __moduleName = context_87 && context_87.id;
    return {
        setters: [
            function (clients_13_1) {
                clients_13 = clients_13_1;
            },
            function (clients_14_1) {
                clients_14 = clients_14_1;
            }
        ],
        execute: function () {
            NuGetResourceClient = class NuGetResourceClient extends clients_14.JsonHttpClientRequest {
                constructor(options, logger) {
                    super(logger, options, {});
                }
                async fetchResource(source) {
                    this.logger.debug("Requesting PackageBaseAddressService from %s", source.url);
                    return await this.requestJson(clients_13.HttpClientRequestMethods.get, source.url)
                        .then((response) => {
                        const packageBaseAddressServices = response.data.resources
                            .filter(res => res["@type"].indexOf('PackageBaseAddress') > -1);
                        // just take one service for now
                        const foundPackageBaseAddressServices = packageBaseAddressServices[0]["@id"];
                        this.logger.debug("Resolved PackageBaseAddressService endpoint: %O", foundPackageBaseAddressServices);
                        return foundPackageBaseAddressServices;
                    })
                        .catch((error) => {
                        this.logger.error("Could not resolve nuget service index. %s", error.data);
                        return Promise.reject(error);
                    });
                }
            };
            exports_87("NuGetResourceClient", NuGetResourceClient);
        }
    };
});
System.register("infrastructure/providers/dotnet/dotnetProvider", ["presentation/providers", "infrastructure/providers/dotnet/dotnetXmlParserFactory", "infrastructure/providers/dotnet/clients/dotnetClient", "infrastructure/providers/dotnet/clients/nugetPackageClient", "infrastructure/providers/dotnet/clients/nugetResourceClient", "core/clients/helpers/urlHelpers", "core/packages"], function (exports_88, context_88) {
    "use strict";
    var providers_8, dotnetXmlParserFactory_1, dotnetClient_1, nugetPackageClient_1, nugetResourceClient_1, urlHelpers_1, packages_10, DotNetVersionLensProvider;
    var __moduleName = context_88 && context_88.id;
    return {
        setters: [
            function (providers_8_1) {
                providers_8 = providers_8_1;
            },
            function (dotnetXmlParserFactory_1_1) {
                dotnetXmlParserFactory_1 = dotnetXmlParserFactory_1_1;
            },
            function (dotnetClient_1_1) {
                dotnetClient_1 = dotnetClient_1_1;
            },
            function (nugetPackageClient_1_1) {
                nugetPackageClient_1 = nugetPackageClient_1_1;
            },
            function (nugetResourceClient_1_1) {
                nugetResourceClient_1 = nugetResourceClient_1_1;
            },
            function (urlHelpers_1_1) {
                urlHelpers_1 = urlHelpers_1_1;
            },
            function (packages_10_1) {
                packages_10 = packages_10_1;
            }
        ],
        execute: function () {
            DotNetVersionLensProvider = class DotNetVersionLensProvider extends providers_8.AbstractVersionLensProvider {
                constructor(config, logger) {
                    super(config, logger);
                    this.dotnetClient = new dotnetClient_1.DotNetClient(config, logger.child({ namespace: 'dotnet cli' }));
                    const requestOptions = {
                        caching: config.caching,
                        http: config.http
                    };
                    this.nugetResourceClient = new nugetResourceClient_1.NuGetResourceClient(requestOptions, logger.child({ namespace: 'dotnet nuget client' }));
                    this.nugetPackageClient = new nugetPackageClient_1.NuGetPackageClient(config, requestOptions, logger.child({ namespace: 'dotnet pkg client' }));
                }
                async fetchVersionLenses(packagePath, document, token) {
                    const packageDependencies = dotnetXmlParserFactory_1.createDependenciesFromXml(document.getText(), this.config.dependencyProperties);
                    if (packageDependencies.length === 0)
                        return null;
                    // ensure latest nuget sources from settings
                    this.config.nuget.defrost();
                    // get each service index source from the dotnet cli
                    const sources = await this.dotnetClient.fetchSources(packagePath);
                    // remote sources only
                    const remoteSources = sources.filter(s => s.protocol === urlHelpers_1.RegistryProtocols.https ||
                        s.protocol === urlHelpers_1.RegistryProtocols.http);
                    // resolve each auto complete service url
                    const promised = remoteSources.map(async (remoteSource) => {
                        return await this.nugetResourceClient.fetchResource(remoteSource);
                    });
                    const autoCompleteUrls = await Promise.all(promised);
                    if (autoCompleteUrls.length === 0)
                        return null;
                    const clientData = { serviceUrls: autoCompleteUrls };
                    const includePrereleases = this.extension.state.prereleasesEnabled.value;
                    const context = {
                        includePrereleases,
                        clientData,
                    };
                    return packages_10.RequestFactory.executeDependencyRequests(packagePath, this.nugetPackageClient, packageDependencies, context);
                }
            };
            exports_88("DotNetVersionLensProvider", DotNetVersionLensProvider);
        }
    };
});
System.register("infrastructure/providers/dotnet/activate", ["infrastructure/providers/dotnet/dotnetProvider", "infrastructure/providers/dotnet/dotnetConfig"], function (exports_89, context_89) {
    "use strict";
    var dotnetProvider_1, dotnetConfig_1;
    var __moduleName = context_89 && context_89.id;
    function activate(extension, logger) {
        const config = new dotnetConfig_1.DotNetConfig(extension);
        return new dotnetProvider_1.DotNetVersionLensProvider(config, logger);
    }
    exports_89("activate", activate);
    return {
        setters: [
            function (dotnetProvider_1_1) {
                dotnetProvider_1 = dotnetProvider_1_1;
            },
            function (dotnetConfig_1_1) {
                dotnetConfig_1 = dotnetConfig_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/dub/dubConfig", ["core/clients", "presentation/providers", "infrastructure/clients"], function (exports_90, context_90) {
    "use strict";
    var clients_15, providers_9, clients_16, DubContributions, DubConfig;
    var __moduleName = context_90 && context_90.id;
    return {
        setters: [
            function (clients_15_1) {
                clients_15 = clients_15_1;
            },
            function (providers_9_1) {
                providers_9 = providers_9_1;
            },
            function (clients_16_1) {
                clients_16 = clients_16_1;
            }
        ],
        execute: function () {
            (function (DubContributions) {
                DubContributions["Caching"] = "dub.caching";
                DubContributions["Http"] = "dub.http";
                DubContributions["DependencyProperties"] = "dub.dependencyProperties";
                DubContributions["ApiUrl"] = "dub.apiUrl";
            })(DubContributions || (DubContributions = {}));
            DubConfig = class DubConfig extends providers_9.AbstractProviderConfig {
                constructor(extension) {
                    super(extension);
                    this.options = {
                        providerName: 'dub',
                        supports: [
                            providers_9.ProviderSupport.Releases,
                            providers_9.ProviderSupport.Prereleases,
                            providers_9.ProviderSupport.InstalledStatuses,
                        ],
                        selector: {
                            language: 'json',
                            scheme: 'file',
                            pattern: '**/{dub.json,dub.selections.json}',
                        }
                    };
                    this.caching = new clients_15.CachingOptions(extension.config, DubContributions.Caching, 'caching');
                    this.http = new clients_16.HttpOptions(extension.config, DubContributions.Http, 'http');
                }
                get dependencyProperties() {
                    return this.extension.config.get(DubContributions.DependencyProperties);
                }
                get apiUrl() {
                    return this.extension.config.get(DubContributions.ApiUrl);
                }
            };
            exports_90("DubConfig", DubConfig);
        }
    };
});
System.register("infrastructure/providers/dub/clients/dubClient", ["core/clients", "core/packages", "infrastructure/clients"], function (exports_91, context_91) {
    "use strict";
    var clients_17, packages_11, clients_18, DubClient;
    var __moduleName = context_91 && context_91.id;
    async function createRemotePackageDocument(client, url, request, semverSpec) {
        const queryParams = {
            minimize: 'true',
        };
        return client.requestJson(clients_17.HttpClientRequestMethods.get, url, queryParams)
            .then(function (httpResponse) {
            const packageInfo = httpResponse.data;
            const { providerName } = request;
            const versionRange = semverSpec.rawVersion;
            const requested = request.package;
            const resolved = {
                name: requested.name,
                version: versionRange,
            };
            const response = {
                source: httpResponse.source,
                status: httpResponse.status,
            };
            const rawVersions = packages_11.VersionHelpers.extractVersionsFromMap(packageInfo.versions);
            // seperate versions to releases and prereleases
            const { releases, prereleases } = packages_11.VersionHelpers.splitReleasesFromArray(rawVersions);
            // analyse suggestions
            const suggestions = createSuggestionTags(versionRange, releases, prereleases);
            return {
                providerName,
                source: packages_11.PackageSourceTypes.Registry,
                response,
                type: semverSpec.type,
                requested,
                resolved,
                suggestions,
            };
        });
    }
    function createSuggestionTags(versionRange, releases, prereleases) {
        const suggestions = packages_11.SuggestionFactory.createSuggestionTags(versionRange, releases, prereleases);
        // check for ~{name} suggestion if no matches found
        const firstSuggestion = suggestions[0];
        const hasNoMatch = firstSuggestion.name === packages_11.PackageVersionStatus.NoMatch;
        const isTildeVersion = versionRange.charAt(0) === '~';
        if (hasNoMatch && isTildeVersion && releases.length > 0) {
            const latestRelease = releases[releases.length - 1];
            if (latestRelease === versionRange) {
                suggestions[0] = packages_11.SuggestionFactory.createMatchesLatest();
                suggestions.pop();
            }
            else {
                // suggest
                suggestions[1] = packages_11.SuggestionFactory.createLatest(latestRelease);
            }
        }
        return suggestions;
    }
    exports_91("createSuggestionTags", createSuggestionTags);
    async function readDubSelections(filePath) {
        return new Promise(function (resolve, reject) {
            const fs = require('fs');
            if (fs.existsSync(filePath) === false) {
                reject(null);
                return;
            }
            fs.readFile(filePath, "utf-8", (err, data) => {
                if (err) {
                    reject(err);
                    return;
                }
                const selectionsJson = JSON.parse(data.toString());
                if (selectionsJson.fileVersion != 1) {
                    reject(new Error(`Unknown dub.selections.json file version ${selectionsJson.fileVersion}`));
                    return;
                }
                resolve(selectionsJson);
            });
        });
    }
    exports_91("readDubSelections", readDubSelections);
    return {
        setters: [
            function (clients_17_1) {
                clients_17 = clients_17_1;
            },
            function (packages_11_1) {
                packages_11 = packages_11_1;
            },
            function (clients_18_1) {
                clients_18 = clients_18_1;
            }
        ],
        execute: function () {
            DubClient = class DubClient extends clients_18.JsonHttpClientRequest {
                constructor(config, options, logger) {
                    super(logger, options, {});
                    this.config = config;
                }
                async fetchPackage(request) {
                    const semverSpec = packages_11.VersionHelpers.parseSemver(request.package.version);
                    const url = `${this.config.apiUrl}/${encodeURIComponent(request.package.name)}/info`;
                    return createRemotePackageDocument(this, url, request, semverSpec)
                        .catch((error) => {
                        if (error.status === 404) {
                            return packages_11.DocumentFactory.createNotFound(request.providerName, request.package, null, packages_11.ResponseFactory.createResponseStatus(error.source, error.status));
                        }
                        return Promise.reject(error);
                    });
                }
            };
            exports_91("DubClient", DubClient);
        }
    };
});
System.register("infrastructure/providers/dub/dubProvider", ["core/packages", "presentation/providers", "presentation/extension", "infrastructure/providers/dub/clients/dubClient"], function (exports_92, context_92) {
    "use strict";
    var packages_12, providers_10, extension_8, dubClient_1, DubVersionLensProvider;
    var __moduleName = context_92 && context_92.id;
    return {
        setters: [
            function (packages_12_1) {
                packages_12 = packages_12_1;
            },
            function (providers_10_1) {
                providers_10 = providers_10_1;
            },
            function (extension_8_1) {
                extension_8 = extension_8_1;
            },
            function (dubClient_1_1) {
                dubClient_1 = dubClient_1_1;
            }
        ],
        execute: function () {
            DubVersionLensProvider = class DubVersionLensProvider extends providers_10.AbstractVersionLensProvider {
                constructor(config, logger) {
                    super(config, logger);
                    this._outdatedCache = {};
                    const requestOptions = {
                        caching: config.caching,
                        http: config.http
                    };
                    this.dubClient = new dubClient_1.DubClient(config, requestOptions, logger.child({ namespace: 'dub pkg client' }));
                }
                async fetchVersionLenses(packagePath, document, token) {
                    const packageDependencies = packages_12.extractPackageDependenciesFromJson(document.getText(), this.config.dependencyProperties);
                    if (packageDependencies.length === 0)
                        return null;
                    const includePrereleases = this.extension.state.prereleasesEnabled.value;
                    const context = {
                        includePrereleases,
                        clientData: null,
                    };
                    return packages_12.RequestFactory.executeDependencyRequests(packagePath, this.dubClient, packageDependencies, context);
                }
                async updateOutdated(packagePath) {
                    const path = require('path');
                    const selectionsFilePath = path.join(packagePath, 'dub.selections.json');
                    return dubClient_1.readDubSelections(selectionsFilePath)
                        .then(selectionsJson => {
                        this._outdatedCache = selectionsJson;
                    })
                        .catch(err => {
                        if (err)
                            console.warn(err);
                    });
                }
                generateDecorations(versionLens) {
                    const currentPackageName = versionLens.package.requested.name;
                    const currentPackageVersion = versionLens.package.requested.version;
                    if (!versionLens.replaceRange)
                        return;
                    if (!this._outdatedCache) {
                        extension_8.renderMissingDecoration(versionLens.replaceRange, this.config.extension.statuses.notInstalledColour);
                        return;
                    }
                    const currentVersion = this._outdatedCache.versions[currentPackageName];
                    if (!currentVersion) {
                        extension_8.renderMissingDecoration(versionLens.replaceRange, this.config.extension.statuses.notInstalledColour);
                        return;
                    }
                    if (packages_12.VersionHelpers.formatWithExistingLeading(currentPackageVersion, currentVersion) == currentPackageVersion) {
                        extension_8.renderInstalledDecoration(versionLens.replaceRange, currentPackageVersion, this.config.extension.statuses.installedColour);
                        return;
                    }
                    extension_8.renderOutdatedDecoration(versionLens.replaceRange, currentVersion, this.config.extension.statuses.outdatedColour);
                }
            };
            exports_92("DubVersionLensProvider", DubVersionLensProvider);
        }
    };
});
System.register("infrastructure/providers/dub/activate", ["infrastructure/providers/dub/dubProvider", "infrastructure/providers/dub/dubConfig"], function (exports_93, context_93) {
    "use strict";
    var dubProvider_1, dubConfig_1;
    var __moduleName = context_93 && context_93.id;
    function activate(extension, logger) {
        const config = new dubConfig_1.DubConfig(extension);
        return new dubProvider_1.DubVersionLensProvider(config, logger);
    }
    exports_93("activate", activate);
    return {
        setters: [
            function (dubProvider_1_1) {
                dubProvider_1 = dubProvider_1_1;
            },
            function (dubConfig_1_1) {
                dubConfig_1 = dubConfig_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/npm/options/githubOptions", ["core/configuration"], function (exports_94, context_94) {
    "use strict";
    var configuration_7, GitHubContributions, GitHubOptions;
    var __moduleName = context_94 && context_94.id;
    return {
        setters: [
            function (configuration_7_1) {
                configuration_7 = configuration_7_1;
            }
        ],
        execute: function () {
            (function (GitHubContributions) {
                GitHubContributions["AccessToken"] = "accessToken";
            })(GitHubContributions || (GitHubContributions = {}));
            GitHubOptions = class GitHubOptions extends configuration_7.Options {
                constructor(config, section) {
                    super(config, section);
                }
                get accessToken() {
                    return this.get(GitHubContributions.AccessToken);
                }
            };
            exports_94("GitHubOptions", GitHubOptions);
        }
    };
});
System.register("infrastructure/providers/npm/npmConfig", ["core/clients", "presentation/providers", "infrastructure/providers/npm/options/githubOptions"], function (exports_95, context_95) {
    "use strict";
    var clients_19, providers_11, githubOptions_1, NpmContributions, NpmConfig;
    var __moduleName = context_95 && context_95.id;
    return {
        setters: [
            function (clients_19_1) {
                clients_19 = clients_19_1;
            },
            function (providers_11_1) {
                providers_11 = providers_11_1;
            },
            function (githubOptions_1_1) {
                githubOptions_1 = githubOptions_1_1;
            }
        ],
        execute: function () {
            (function (NpmContributions) {
                NpmContributions["Caching"] = "npm.caching";
                NpmContributions["Http"] = "npm.http";
                NpmContributions["Github"] = "npm.github";
                NpmContributions["DependencyProperties"] = "npm.dependencyProperties";
                NpmContributions["DistTagFilter"] = "npm.distTagFilter";
            })(NpmContributions || (NpmContributions = {}));
            NpmConfig = class NpmConfig extends providers_11.AbstractProviderConfig {
                constructor(extension) {
                    super(extension);
                    this.options = {
                        providerName: 'npm',
                        supports: [
                            providers_11.ProviderSupport.Releases,
                            providers_11.ProviderSupport.Prereleases,
                            providers_11.ProviderSupport.InstalledStatuses,
                        ],
                        selector: {
                            language: 'json',
                            scheme: 'file',
                            pattern: '**/package.json',
                        }
                    };
                    this.caching = new clients_19.CachingOptions(extension.config, NpmContributions.Caching, 'caching');
                    this.http = new clients_19.HttpOptions(extension.config, NpmContributions.Http, 'http');
                    this.github = new githubOptions_1.GitHubOptions(extension.config, NpmContributions.Github);
                }
                get dependencyProperties() {
                    return this.extension.config.get(NpmContributions.DependencyProperties);
                }
                get distTagFilter() {
                    return this.extension.config.get(NpmContributions.DistTagFilter);
                }
            };
            exports_95("NpmConfig", NpmConfig);
        }
    };
});
System.register("infrastructure/providers/npm/npmUtils", ["core/packages"], function (exports_96, context_96) {
    "use strict";
    var packages_13;
    var __moduleName = context_96 && context_96.id;
    function npmReplaceVersion(packageInfo, newVersion) {
        if (packageInfo.source === packages_13.PackageSourceTypes.Github) {
            return replaceGitVersion(packageInfo, newVersion);
        }
        if (packageInfo.type === packages_13.PackageVersionTypes.Alias) {
            return replaceAliasVersion(packageInfo, newVersion);
        }
        // fallback to default
        return packages_13.VersionHelpers.formatWithExistingLeading(packageInfo.requested.version, newVersion);
    }
    exports_96("npmReplaceVersion", npmReplaceVersion);
    function replaceGitVersion(packageInfo, newVersion) {
        return packageInfo.requested.version.replace(packageInfo.resolved.version, newVersion);
    }
    function replaceAliasVersion(packageInfo, newVersion) {
        // preserve the leading symbol from the existing version
        const preservedLeadingVersion = packages_13.VersionHelpers.formatWithExistingLeading(packageInfo.requested.version, newVersion);
        return `npm:${packageInfo.resolved.name}@${preservedLeadingVersion}`;
    }
    function convertNpmErrorToResponse(error, source) {
        return {
            source,
            status: error.code,
            data: error.message,
        };
    }
    exports_96("convertNpmErrorToResponse", convertNpmErrorToResponse);
    return {
        setters: [
            function (packages_13_1) {
                packages_13 = packages_13_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/npm/models/npaSpec", [], function (exports_97, context_97) {
    "use strict";
    var NpaTypes;
    var __moduleName = context_97 && context_97.id;
    return {
        setters: [],
        execute: function () {
            (function (NpaTypes) {
                NpaTypes["Git"] = "git";
                NpaTypes["Remote"] = "remote";
                NpaTypes["File"] = "file";
                NpaTypes["Directory"] = "directory";
                NpaTypes["Tag"] = "tag";
                NpaTypes["Version"] = "version";
                NpaTypes["Range"] = "range";
                NpaTypes["Alias"] = "alias";
            })(NpaTypes || (NpaTypes = {}));
            exports_97("NpaTypes", NpaTypes);
        }
    };
});
System.register("infrastructure/providers/npm/factories/packageFactory", ["core/packages"], function (exports_98, context_98) {
    "use strict";
    var packages_14, fileDependencyRegex;
    var __moduleName = context_98 && context_98.id;
    function createDirectory(providerName, requested, response, npaSpec) {
        const fileRegExpResult = fileDependencyRegex.exec(requested.version);
        if (!fileRegExpResult) {
            return packages_14.DocumentFactory.createInvalidVersion(providerName, requested, response, npaSpec.type // todo create a converter
            );
        }
        const source = packages_14.PackageSourceTypes.Directory;
        const type = packages_14.PackageVersionTypes.Version;
        const resolved = {
            name: npaSpec.name,
            version: fileRegExpResult[1],
        };
        const suggestions = [
            {
                name: 'file://',
                version: resolved.version,
                flags: packages_14.PackageSuggestionFlags.release
            },
        ];
        return {
            providerName,
            source,
            type,
            requested,
            response,
            resolved,
            suggestions
        };
    }
    exports_98("createDirectory", createDirectory);
    return {
        setters: [
            function (packages_14_1) {
                packages_14 = packages_14_1;
            }
        ],
        execute: function () {
            exports_98("fileDependencyRegex", fileDependencyRegex = /^file:(.*)$/);
        }
    };
});
System.register("infrastructure/providers/npm/clients/pacoteClient", ["core/packages", "core/clients", "infrastructure/providers/npm/models/npaSpec", "infrastructure/providers/npm/npmUtils"], function (exports_99, context_99) {
    "use strict";
    var packages_15, clients_20, npaSpec_1, NpmUtils, PacoteClient;
    var __moduleName = context_99 && context_99.id;
    return {
        setters: [
            function (packages_15_1) {
                packages_15 = packages_15_1;
            },
            function (clients_20_1) {
                clients_20 = clients_20_1;
            },
            function (npaSpec_1_1) {
                npaSpec_1 = npaSpec_1_1;
            },
            function (NpmUtils_1) {
                NpmUtils = NpmUtils_1;
            }
        ],
        execute: function () {
            PacoteClient = class PacoteClient extends clients_20.AbstractClientRequest {
                constructor(config, logger) {
                    super(config.caching);
                    this.config = config;
                }
                async fetchPackage(request, npaSpec) {
                    const cacheKey = `${request.package.name}@${request.package.version}_${request.package.path}`;
                    if (this.cache.options.duration > 0 && this.cache.hasExpired(cacheKey) === false) {
                        const cachedResp = this.cache.get(cacheKey);
                        if (cachedResp.rejected)
                            return Promise.reject(cachedResp);
                        cachedResp.data.response.source = clients_20.ClientResponseSource.cache;
                        return Promise.resolve(cachedResp.data);
                    }
                    const pacote = require('pacote');
                    const npmConfig = require('libnpmconfig');
                    // get npm config
                    const npmOpts = npmConfig.read({
                        where: request.package.path,
                        fullMetadata: false,
                    }, {
                        cwd: request.package.path,
                    });
                    return pacote.packument(npaSpec, npmOpts)
                        .then(function (packumentResponse) {
                        const { compareLoose } = require("semver");
                        const { providerName } = request;
                        const source = packages_15.PackageSourceTypes.Registry;
                        const type = npaSpec.type;
                        let versionRange = (type === packages_15.PackageVersionTypes.Alias) ?
                            npaSpec.subSpec.rawSpec :
                            npaSpec.rawSpec;
                        const resolved = {
                            name: (type === packages_15.PackageVersionTypes.Alias) ?
                                npaSpec.subSpec.name :
                                npaSpec.name,
                            version: versionRange,
                        };
                        // extract prereleases from dist tags
                        const distTags = packumentResponse['dist-tags'] || {};
                        const prereleases = packages_15.VersionHelpers.filterPrereleasesFromDistTags(distTags).sort(compareLoose);
                        const latestTaggedVersion = distTags['latest'];
                        // extract releases
                        let releases = Object.keys(packumentResponse.versions || {}).sort(compareLoose);
                        if (latestTaggedVersion) {
                            // cap the releases to the latest tagged version
                            releases = packages_15.VersionHelpers.lteFromArray(releases, latestTaggedVersion);
                        }
                        const response = {
                            source: clients_20.ClientResponseSource.remote,
                            status: 200,
                        };
                        // check if the version requested is a tag. eg latest|next
                        const requested = request.package;
                        if (npaSpec.type === npaSpec_1.NpaTypes.Tag) {
                            versionRange = distTags[requested.version];
                            if (!versionRange) {
                                return packages_15.DocumentFactory.createNoMatch(providerName, source, type, requested, response, 
                                // suggest the latest release if available
                                releases.length > 0 ? releases[releases.length - 1] : null);
                            }
                        }
                        // analyse suggestions
                        const suggestions = packages_15.SuggestionFactory.createSuggestionTags(versionRange, releases, prereleases);
                        return {
                            providerName,
                            source,
                            response,
                            type,
                            requested,
                            resolved,
                            suggestions,
                        };
                    }).then(document => {
                        this.createCachedResponse(cacheKey, 200, document, false);
                        return document;
                    }).catch(response => {
                        this.createCachedResponse(cacheKey, response.code, response.message, true);
                        return Promise.reject(NpmUtils.convertNpmErrorToResponse(response, clients_20.ClientResponseSource.remote));
                    });
                }
            };
            exports_99("PacoteClient", PacoteClient);
        }
    };
});
System.register("infrastructure/providers/npm/clients/githubClient", ["core/clients", "core/packages", "infrastructure/clients"], function (exports_100, context_100) {
    "use strict";
    var clients_21, packages_16, clients_22, defaultHeaders, GithubClient;
    var __moduleName = context_100 && context_100.id;
    return {
        setters: [
            function (clients_21_1) {
                clients_21 = clients_21_1;
            },
            function (packages_16_1) {
                packages_16 = packages_16_1;
            },
            function (clients_22_1) {
                clients_22 = clients_22_1;
            }
        ],
        execute: function () {
            defaultHeaders = {
                accept: 'application\/vnd.github.v3+json',
                'user-agent': 'vscode-contrib/vscode-versionlens'
            };
            GithubClient = class GithubClient extends clients_22.JsonHttpClientRequest {
                constructor(config, options, logger) {
                    super(logger, options, defaultHeaders);
                    this.config = config;
                }
                fetchGithub(request, npaSpec) {
                    const { validRange } = require('semver');
                    if (npaSpec.gitRange) {
                        // we have a semver:x.x.x
                        return this.fetchTags(request, npaSpec);
                    }
                    if (validRange(npaSpec.gitCommittish, packages_16.VersionHelpers.loosePrereleases)) {
                        // we have a #x.x.x
                        npaSpec.gitRange = npaSpec.gitCommittish;
                        return this.fetchTags(request, npaSpec);
                    }
                    // we have a #commit
                    return this.fetchCommits(request, npaSpec);
                }
                fetchTags(request, npaSpec) {
                    // todo pass in auth
                    const { user, project } = npaSpec.hosted;
                    const tagsRepoUrl = `https://api.github.com/repos/${user}/${project}/tags`;
                    let headers = {};
                    if (this.config.github.accessToken && this.config.github.accessToken.length > 0) {
                        headers.authorization = `token ${this.config.github.accessToken}`;
                    }
                    return this.requestJson(clients_21.HttpClientRequestMethods.get, tagsRepoUrl, {})
                        .then(function (response) {
                        // extract versions
                        const tags = response.data;
                        const rawVersions = tags.map((tag) => tag.name);
                        const allVersions = packages_16.VersionHelpers.filterSemverVersions(rawVersions);
                        const source = packages_16.PackageSourceTypes.Github;
                        const { providerName } = request;
                        const requested = request.package;
                        const type = npaSpec.gitRange ?
                            packages_16.PackageVersionTypes.Range :
                            packages_16.PackageVersionTypes.Version;
                        const versionRange = npaSpec.gitRange;
                        const resolved = {
                            name: project,
                            version: versionRange,
                        };
                        // seperate versions to releases and prereleases
                        const { releases, prereleases } = packages_16.VersionHelpers.splitReleasesFromArray(allVersions);
                        // analyse suggestions
                        const suggestions = packages_16.SuggestionFactory.createSuggestionTags(versionRange, releases, prereleases);
                        return {
                            providerName,
                            source,
                            response,
                            type,
                            requested,
                            resolved,
                            suggestions
                        };
                    });
                }
                fetchCommits(request, npaSpec) {
                    // todo pass in auth
                    const { user, project } = npaSpec.hosted;
                    const commitsRepoUrl = `https://api.github.com/repos/${user}/${project}/commits`;
                    return this.requestJson(clients_21.HttpClientRequestMethods.get, commitsRepoUrl, {})
                        .then((response) => {
                        const commitInfos = response.data;
                        const commits = commitInfos.map((commit) => commit.sha);
                        const source = packages_16.PackageSourceTypes.Github;
                        const { providerName } = request;
                        const requested = request.package;
                        const type = packages_16.PackageVersionTypes.Committish;
                        const versionRange = npaSpec.gitCommittish;
                        if (commits.length === 0) {
                            // no commits found
                            return packages_16.DocumentFactory.createNotFound(providerName, requested, packages_16.PackageVersionTypes.Version, packages_16.ResponseFactory.createResponseStatus(response.source, 404));
                        }
                        const commitIndex = commits.findIndex(commit => commit.indexOf(versionRange) > -1);
                        const latestCommit = commits[commits.length - 1].substr(0, 8);
                        const noMatch = commitIndex === -1;
                        const isLatest = versionRange === latestCommit;
                        const resolved = {
                            name: project,
                            version: versionRange,
                        };
                        const suggestions = [];
                        if (noMatch) {
                            suggestions.push(packages_16.SuggestionFactory.createNoMatch(), packages_16.SuggestionFactory.createLatest(latestCommit));
                        }
                        else if (isLatest) {
                            suggestions.push(packages_16.SuggestionFactory.createMatchesLatest());
                        }
                        else if (commitIndex > 0) {
                            suggestions.push(packages_16.SuggestionFactory.createFixedStatus(versionRange), packages_16.SuggestionFactory.createLatest(latestCommit));
                        }
                        return {
                            providerName,
                            source,
                            response,
                            type,
                            requested,
                            resolved,
                            suggestions,
                            gitSpec: npaSpec.saveSpec
                        };
                    });
                }
            };
            exports_100("GithubClient", GithubClient);
        }
    };
});
System.register("infrastructure/providers/npm/clients/npmPackageClient", ["core/packages", "core/clients", "infrastructure/providers/npm/factories/packageFactory", "infrastructure/providers/npm/models/npaSpec", "infrastructure/providers/npm/clients/pacoteClient", "infrastructure/providers/npm/clients/githubClient", "infrastructure/providers/npm/npmUtils"], function (exports_101, context_101) {
    "use strict";
    var packages_17, clients_23, PackageFactory, npaSpec_2, pacoteClient_1, githubClient_1, NpmUtils, NpmPackageClient;
    var __moduleName = context_101 && context_101.id;
    return {
        setters: [
            function (packages_17_1) {
                packages_17 = packages_17_1;
            },
            function (clients_23_1) {
                clients_23 = clients_23_1;
            },
            function (PackageFactory_1) {
                PackageFactory = PackageFactory_1;
            },
            function (npaSpec_2_1) {
                npaSpec_2 = npaSpec_2_1;
            },
            function (pacoteClient_1_1) {
                pacoteClient_1 = pacoteClient_1_1;
            },
            function (githubClient_1_1) {
                githubClient_1 = githubClient_1_1;
            },
            function (NpmUtils_2) {
                NpmUtils = NpmUtils_2;
            }
        ],
        execute: function () {
            NpmPackageClient = class NpmPackageClient {
                constructor(config, logger) {
                    this.config = config;
                    this.logger = logger;
                    this.pacoteClient = new pacoteClient_1.PacoteClient(config, logger.child({ namespace: 'npm pacote' }));
                    const requestOptions = {
                        caching: config.caching,
                        http: config.http
                    };
                    this.githubClient = new githubClient_1.GithubClient(config, requestOptions, logger.child({ namespace: 'npm github' }));
                }
                async fetchPackage(request) {
                    const npa = require('npm-package-arg');
                    return new Promise((resolve, reject) => {
                        let npaSpec;
                        // try parse the package
                        try {
                            npaSpec = npa.resolve(request.package.name, request.package.version, request.package.path);
                        }
                        catch (error) {
                            return reject(NpmUtils.convertNpmErrorToResponse(error, clients_23.ClientResponseSource.local));
                        }
                        // return if directory or file document
                        if (npaSpec.type === npaSpec_2.NpaTypes.Directory || npaSpec.type === npaSpec_2.NpaTypes.File) {
                            return resolve(PackageFactory.createDirectory(request.providerName, request.package, packages_17.ResponseFactory.createResponseStatus(clients_23.ClientResponseSource.local, 200), npaSpec));
                        }
                        if (npaSpec.type === npaSpec_2.NpaTypes.Git) {
                            if (!npaSpec.hosted) {
                                // could not resolve
                                return reject({
                                    status: 'EUNSUPPORTEDPROTOCOL',
                                    data: 'Git url could not be resolved',
                                    source: clients_23.ClientResponseSource.local
                                });
                            }
                            if (!npaSpec.gitCommittish && npaSpec.hosted.default !== 'shortcut') {
                                return resolve(packages_17.DocumentFactory.createFixed(request.providerName, packages_17.PackageSourceTypes.Git, request.package, packages_17.ResponseFactory.createResponseStatus(clients_23.ClientResponseSource.local, 0), packages_17.PackageVersionTypes.Committish, 'git repository'));
                            }
                            // resolve tags, committishes
                            return resolve(this.githubClient.fetchGithub(request, npaSpec));
                        }
                        // otherwise return registry result
                        return resolve(this.pacoteClient.fetchPackage(request, npaSpec));
                    }).catch(response => {
                        if (!response.data) {
                            response = NpmUtils.convertNpmErrorToResponse(response, clients_23.ClientResponseSource.remote);
                        }
                        if (response.status === 404 || response.status === 'E404') {
                            return packages_17.DocumentFactory.createNotFound(request.providerName, request.package, null, packages_17.ResponseFactory.createResponseStatus(response.source, 404));
                        }
                        if (response.status === 401 || response.status === 'E401') {
                            return packages_17.DocumentFactory.createNotAuthorized(request.providerName, request.package, null, packages_17.ResponseFactory.createResponseStatus(response.source, 401));
                        }
                        if (response.status === 'ECONNREFUSED') {
                            return packages_17.DocumentFactory.createConnectionRefused(request.providerName, request.package, null, packages_17.ResponseFactory.createResponseStatus(response.source, -1));
                        }
                        if (response.status === 'EINVALIDTAGNAME' || response.data.includes('Invalid comparator:')) {
                            return packages_17.DocumentFactory.createInvalidVersion(request.providerName, request.package, packages_17.ResponseFactory.createResponseStatus(response.source, 404), null);
                        }
                        if (response.status === 'EUNSUPPORTEDPROTOCOL') {
                            return packages_17.DocumentFactory.createNotSupported(request.providerName, request.package, packages_17.ResponseFactory.createResponseStatus(response.source, 404), null);
                        }
                        if (response.status === 128) {
                            return packages_17.DocumentFactory.createGitFailed(request.providerName, request.package, packages_17.ResponseFactory.createResponseStatus(response.source, 404), null);
                        }
                        return Promise.reject(response);
                    });
                }
            };
            exports_101("NpmPackageClient", NpmPackageClient);
        }
    };
});
System.register("infrastructure/providers/npm/npmProvider", ["core/packages", "presentation/providers", "infrastructure/providers/npm/npmUtils", "infrastructure/providers/npm/clients/npmPackageClient"], function (exports_102, context_102) {
    "use strict";
    var packages_18, providers_12, npmUtils_1, npmPackageClient_1, NpmVersionLensProvider;
    var __moduleName = context_102 && context_102.id;
    return {
        setters: [
            function (packages_18_1) {
                packages_18 = packages_18_1;
            },
            function (providers_12_1) {
                providers_12 = providers_12_1;
            },
            function (npmUtils_1_1) {
                npmUtils_1 = npmUtils_1_1;
            },
            function (npmPackageClient_1_1) {
                npmPackageClient_1 = npmPackageClient_1_1;
            }
        ],
        execute: function () {
            NpmVersionLensProvider = class NpmVersionLensProvider extends providers_12.AbstractVersionLensProvider {
                constructor(config, logger) {
                    super(config, logger);
                    this.packageClient = new npmPackageClient_1.NpmPackageClient(config, logger);
                    this.customReplaceFn = npmUtils_1.npmReplaceVersion;
                }
                async fetchVersionLenses(packagePath, document, token) {
                    const packageDependencies = packages_18.extractPackageDependenciesFromJson(document.getText(), this.config.dependencyProperties);
                    if (packageDependencies.length === 0)
                        return null;
                    const includePrereleases = this.extension.state.prereleasesEnabled.value;
                    const context = {
                        includePrereleases,
                        clientData: null,
                    };
                    if (this.config.github.accessToken &&
                        this.config.github.accessToken.length > 0) {
                        // defrost github parameters
                        this.config.github.defrost();
                    }
                    return packages_18.RequestFactory.executeDependencyRequests(packagePath, this.packageClient, packageDependencies, context);
                }
                async updateOutdated(packagePath) {
                }
            }; // End NpmCodeLensProvider
            exports_102("NpmVersionLensProvider", NpmVersionLensProvider);
        }
    };
});
System.register("infrastructure/providers/jspm/jspmPackageParser", ["core/packages"], function (exports_103, context_103) {
    "use strict";
    var packages_19;
    var __moduleName = context_103 && context_103.id;
    function extractPackageDependenciesFromJson(json, filterPropertyNames) {
        const jsonParser = require("jsonc-parser");
        const jsonErrors = [];
        const jsonTree = jsonParser.parseTree(json, jsonErrors);
        if (!jsonTree || jsonTree.children.length === 0 || jsonErrors.length > 0)
            return [];
        const children = jsonTree.children;
        for (let i = 0; i < children.length; i++) {
            const node = children[i];
            const [keyEntry, valueEntry] = node.children;
            if (keyEntry.value === 'jspm') {
                return packages_19.extractFromNodes(valueEntry.children, filterPropertyNames);
            }
        }
        return [];
    }
    exports_103("extractPackageDependenciesFromJson", extractPackageDependenciesFromJson);
    return {
        setters: [
            function (packages_19_1) {
                packages_19 = packages_19_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/jspm/jspmConfig", ["infrastructure/providers/npm/npmConfig"], function (exports_104, context_104) {
    "use strict";
    var npmConfig_1, JspmConfig;
    var __moduleName = context_104 && context_104.id;
    return {
        setters: [
            function (npmConfig_1_1) {
                npmConfig_1 = npmConfig_1_1;
            }
        ],
        execute: function () {
            JspmConfig = class JspmConfig extends npmConfig_1.NpmConfig {
                constructor(extension) {
                    super(extension);
                    this.options.providerName = 'jspm';
                }
            };
            exports_104("JspmConfig", JspmConfig);
        }
    };
});
System.register("infrastructure/providers/jspm/jspmProvider", ["core/packages", "infrastructure/providers/npm/npmProvider", "infrastructure/providers/jspm/jspmPackageParser"], function (exports_105, context_105) {
    "use strict";
    var packages_20, npmProvider_1, jspmPackageParser_1, JspmVersionLensProvider;
    var __moduleName = context_105 && context_105.id;
    return {
        setters: [
            function (packages_20_1) {
                packages_20 = packages_20_1;
            },
            function (npmProvider_1_1) {
                npmProvider_1 = npmProvider_1_1;
            },
            function (jspmPackageParser_1_1) {
                jspmPackageParser_1 = jspmPackageParser_1_1;
            }
        ],
        execute: function () {
            JspmVersionLensProvider = class JspmVersionLensProvider extends npmProvider_1.NpmVersionLensProvider {
                constructor(config, logger) {
                    super(config, logger);
                }
                async fetchVersionLenses(packagePath, document, token) {
                    const packageDependencies = jspmPackageParser_1.extractPackageDependenciesFromJson(document.getText(), this.config.dependencyProperties);
                    if (packageDependencies.length === 0)
                        return null;
                    const includePrereleases = this.extension.state.prereleasesEnabled.value;
                    const context = {
                        includePrereleases,
                        clientData: null,
                    };
                    return packages_20.RequestFactory.executeDependencyRequests(packagePath, this.packageClient, packageDependencies, context);
                }
            };
            exports_105("JspmVersionLensProvider", JspmVersionLensProvider);
        }
    };
});
System.register("infrastructure/providers/jspm/activate", ["infrastructure/providers/jspm/jspmProvider", "infrastructure/providers/jspm/jspmConfig"], function (exports_106, context_106) {
    "use strict";
    var jspmProvider_1, jspmConfig_1;
    var __moduleName = context_106 && context_106.id;
    function activate(extension, logger) {
        const config = new jspmConfig_1.JspmConfig(extension);
        return new jspmProvider_1.JspmVersionLensProvider(config, logger);
    }
    exports_106("activate", activate);
    return {
        setters: [
            function (jspmProvider_1_1) {
                jspmProvider_1 = jspmProvider_1_1;
            },
            function (jspmConfig_1_1) {
                jspmConfig_1 = jspmConfig_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/maven/definitions/mavenProjectProperty", [], function (exports_107, context_107) {
    "use strict";
    var __moduleName = context_107 && context_107.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/maven/mavenXmlParserFactory", [], function (exports_108, context_108) {
    "use strict";
    var __moduleName = context_108 && context_108.id;
    function createDependenciesFromXml(xml, includePropertyNames) {
        const xmldoc = require('xmldoc');
        let document = null;
        try {
            document = new xmldoc.XmlDocument(xml);
        }
        catch {
            document = null;
        }
        if (!document)
            return [];
        const properties = extractPropertiesFromDocument(document);
        return extractPackageLensDataFromNodes(document, properties, includePropertyNames);
    }
    exports_108("createDependenciesFromXml", createDependenciesFromXml);
    function extractPackageLensDataFromNodes(xmlDoc, properties, includePropertyNames) {
        const collector = [];
        xmlDoc.eachChild(group => {
            switch (group.name) {
                case "dependencies":
                    group.eachChild(childNode => {
                        if (!includePropertyNames.includes(childNode.name))
                            return;
                        collectFromChildVersionTag(childNode, properties, collector);
                    });
                    break;
                case "parent":
                    if (!includePropertyNames.includes(group.name))
                        return;
                    collectFromChildVersionTag(group, properties, collector);
                    break;
                default:
                    break;
            }
        });
        return collector;
    }
    function collectFromChildVersionTag(parentNode, properties, collector) {
        parentNode.eachChild(childNode => {
            let versionNode;
            if (childNode.name !== "version")
                return;
            if (childNode.val.indexOf("$") >= 0) {
                let name = childNode.val.replace(/\$|\{|\}/ig, '');
                versionNode = properties.filter(property => {
                    return property.name === name;
                })[0];
            }
            else {
                versionNode = childNode;
            }
            const nameRange = {
                start: parentNode.startTagPosition,
                end: parentNode.startTagPosition,
            };
            const versionRange = {
                start: versionNode.position,
                end: versionNode.position + versionNode.val.length,
            };
            let group = parentNode.childNamed("groupId").val;
            let artifact = parentNode.childNamed("artifactId").val;
            let match = /\$\{(.*)\}/ig.exec(artifact);
            if (match) {
                let property = properties.filter(property => property.name === match[1]);
                artifact = artifact.replace(/\$\{.*\}/ig, property[0].val);
            }
            const packageInfo = {
                name: group + ":" + artifact,
                version: versionNode.val,
            };
            collector.push({
                nameRange,
                versionRange,
                packageInfo
            });
        });
    }
    function extractPropertiesFromDocument(xmlDoc) {
        let properties = [];
        let propertiesCurrentPom = xmlDoc.descendantWithPath("properties");
        propertiesCurrentPom.eachChild(property => {
            properties.push({
                name: property.name,
                val: property.val,
                position: property.position
            });
        });
        return properties;
    }
    function extractReposUrlsFromXml(stdout) {
        const xmldoc = require('xmldoc');
        const regex = /<\?xml(.+\r?\n?)+\/settings>/gm;
        const xmlString = regex.exec(stdout.toString())[0];
        const xml = new xmldoc.XmlDocument(xmlString);
        const localRepository = xml.descendantWithPath("localRepository");
        const results = [
            localRepository.val
        ];
        let repositoriesXml = xml.descendantWithPath("profiles.profile.repositories")
            .childrenNamed("repository");
        repositoriesXml.forEach(repositoryXml => {
            results.push(repositoryXml.childNamed("url").val);
        });
        return results;
    }
    exports_108("extractReposUrlsFromXml", extractReposUrlsFromXml);
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/maven/mavenConfig", ["core/clients", "presentation/providers"], function (exports_109, context_109) {
    "use strict";
    var clients_24, providers_13, MavenContributions, MavenConfig;
    var __moduleName = context_109 && context_109.id;
    return {
        setters: [
            function (clients_24_1) {
                clients_24 = clients_24_1;
            },
            function (providers_13_1) {
                providers_13 = providers_13_1;
            }
        ],
        execute: function () {
            (function (MavenContributions) {
                MavenContributions["Caching"] = "maven.caching";
                MavenContributions["Http"] = "maven.http";
                MavenContributions["DependencyProperties"] = "maven.dependencyProperties";
                MavenContributions["TagFilter"] = "maven.tagFilter";
                MavenContributions["ApiUrl"] = "maven.apiUrl";
            })(MavenContributions || (MavenContributions = {}));
            MavenConfig = class MavenConfig extends providers_13.AbstractProviderConfig {
                constructor(extension) {
                    super(extension);
                    this.options = {
                        providerName: 'maven',
                        supports: [
                            providers_13.ProviderSupport.Releases,
                            providers_13.ProviderSupport.Prereleases,
                        ],
                        selector: {
                            language: 'xml',
                            scheme: 'file',
                            pattern: '**/pom.xml',
                        }
                    };
                    this.caching = new clients_24.CachingOptions(extension.config, MavenContributions.Caching, 'caching');
                    this.http = new clients_24.HttpOptions(extension.config, MavenContributions.Http, 'http');
                }
                get dependencyProperties() {
                    return this.extension.config.get(MavenContributions.DependencyProperties);
                }
                get tagFilter() {
                    return this.extension.config.get(MavenContributions.DependencyProperties);
                }
                get apiUrl() {
                    return this.extension.config.get(MavenContributions.ApiUrl);
                }
            };
            exports_109("MavenConfig", MavenConfig);
        }
    };
});
System.register("infrastructure/providers/maven/definitions/mavenRepository", [], function (exports_110, context_110) {
    "use strict";
    var __moduleName = context_110 && context_110.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/maven/definitions/mavenClientData", [], function (exports_111, context_111) {
    "use strict";
    var __moduleName = context_111 && context_111.id;
    return {
        setters: [],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/maven/clients/mvnClient", ["core/clients", "infrastructure/clients", "infrastructure/providers/maven/mavenXmlParserFactory"], function (exports_112, context_112) {
    "use strict";
    var clients_25, clients_26, MavenXmlFactory, MvnClient;
    var __moduleName = context_112 && context_112.id;
    return {
        setters: [
            function (clients_25_1) {
                clients_25 = clients_25_1;
            },
            function (clients_26_1) {
                clients_26 = clients_26_1;
            },
            function (MavenXmlFactory_1) {
                MavenXmlFactory = MavenXmlFactory_1;
            }
        ],
        execute: function () {
            MvnClient = class MvnClient extends clients_26.ProcessClientRequest {
                constructor(config, logger) {
                    super(config.caching, logger);
                    this.config = config;
                }
                async fetchRepositories(cwd) {
                    const promisedCli = super.request('mvn ', ['help:effective-settings'], cwd);
                    return promisedCli.then(result => {
                        const { data } = result;
                        // check we have some data
                        if (data.length === 0)
                            return [];
                        return MavenXmlFactory.extractReposUrlsFromXml(data);
                    }).catch(error => {
                        return [];
                    }).then((repos) => {
                        if (repos.length === 0) {
                            // this.config.getDefaultRepository()
                            repos.push("https://repo.maven.apache.org/maven2/");
                        }
                        return repos;
                    }).then((repos) => {
                        // parse urls to Array<MavenRepository.
                        return repos.map(url => {
                            const protocol = clients_25.UrlHelpers.getProtocolFromUrl(url);
                            return {
                                url,
                                protocol,
                            };
                        });
                    });
                }
            };
            exports_112("MvnClient", MvnClient);
        }
    };
});
System.register("infrastructure/providers/maven/clients/mavenClient", ["core/packages", "core/clients", "infrastructure/clients"], function (exports_113, context_113) {
    "use strict";
    var packages_21, clients_27, clients_28, MavenClient;
    var __moduleName = context_113 && context_113.id;
    async function createRemotePackageDocument(client, url, request, semverSpec) {
        return client.request(clients_27.HttpClientRequestMethods.get, url, {})
            .then(function (httpResponse) {
            const { data } = httpResponse;
            const source = packages_21.PackageSourceTypes.Registry;
            const { providerName } = request;
            const requested = request.package;
            const versionRange = semverSpec.rawVersion;
            const response = {
                source: httpResponse.source,
                status: httpResponse.status,
            };
            // extract versions form xml
            const rawVersions = getVersionsFromPackageXml(data);
            // extract semver versions only
            const semverVersions = packages_21.VersionHelpers.filterSemverVersions(rawVersions);
            // seperate versions to releases and prereleases
            const { releases, prereleases } = packages_21.VersionHelpers.splitReleasesFromArray(semverVersions);
            const resolved = {
                name: requested.name,
                version: versionRange,
            };
            // analyse suggestions
            const suggestions = packages_21.SuggestionFactory.createSuggestionTags(versionRange, releases, prereleases);
            return {
                providerName,
                source,
                response,
                type: semverSpec.type,
                requested,
                resolved,
                suggestions,
            };
        });
    }
    function getVersionsFromPackageXml(packageXml) {
        const xmldoc = require('xmldoc');
        let xmlRootNode = new xmldoc.XmlDocument(packageXml);
        let xmlVersioningNode = xmlRootNode.childNamed("versioning");
        let xmlVersionsList = xmlVersioningNode.childNamed("versions").childrenNamed("version");
        let versions = [];
        xmlVersionsList.forEach(xmlVersionNode => {
            versions.push(xmlVersionNode.val);
        });
        return versions;
    }
    return {
        setters: [
            function (packages_21_1) {
                packages_21 = packages_21_1;
            },
            function (clients_27_1) {
                clients_27 = clients_27_1;
            },
            function (clients_28_1) {
                clients_28 = clients_28_1;
            }
        ],
        execute: function () {
            MavenClient = class MavenClient extends clients_28.HttpClientRequest {
                constructor(config, options, logger) {
                    super(logger, options, {});
                    this.config = config;
                }
                async fetchPackage(request) {
                    const semverSpec = packages_21.VersionHelpers.parseSemver(request.package.version);
                    const { repositories } = request.clientData;
                    const url = repositories[0].url;
                    let [group, artifact] = request.package.name.split(':');
                    let search = group.replace(/\./g, "/") + "/" + artifact;
                    const queryUrl = `${url}${search}/maven-metadata.xml`;
                    return createRemotePackageDocument(this, queryUrl, request, semverSpec)
                        .catch((error) => {
                        if (error.status === 404) {
                            return packages_21.DocumentFactory.createNotFound(request.providerName, request.package, semverSpec.type, packages_21.ResponseFactory.createResponseStatus(error.source, error.status));
                        }
                        return Promise.reject(error);
                    });
                }
            };
            exports_113("MavenClient", MavenClient);
        }
    };
});
System.register("infrastructure/providers/maven/mavenProvider", ["core/clients", "core/packages", "presentation/providers", "infrastructure/providers/maven/mavenXmlParserFactory", "infrastructure/providers/maven/clients/mvnClient", "infrastructure/providers/maven/clients/mavenClient"], function (exports_114, context_114) {
    "use strict";
    var clients_29, packages_22, providers_14, MavenXmlFactory, mvnClient_1, mavenClient_1, MavenVersionLensProvider;
    var __moduleName = context_114 && context_114.id;
    return {
        setters: [
            function (clients_29_1) {
                clients_29 = clients_29_1;
            },
            function (packages_22_1) {
                packages_22 = packages_22_1;
            },
            function (providers_14_1) {
                providers_14 = providers_14_1;
            },
            function (MavenXmlFactory_2) {
                MavenXmlFactory = MavenXmlFactory_2;
            },
            function (mvnClient_1_1) {
                mvnClient_1 = mvnClient_1_1;
            },
            function (mavenClient_1_1) {
                mavenClient_1 = mavenClient_1_1;
            }
        ],
        execute: function () {
            MavenVersionLensProvider = class MavenVersionLensProvider extends providers_14.AbstractVersionLensProvider {
                constructor(config, logger) {
                    super(config, logger);
                    const requestOptions = {
                        caching: config.caching,
                        http: config.http
                    };
                    this.mvnClient = new mvnClient_1.MvnClient(config, logger.child({ namespace: 'maven cli' }));
                    this.mavenClient = new mavenClient_1.MavenClient(config, requestOptions, logger.child({ namespace: 'maven pkg client' }));
                }
                async fetchVersionLenses(packagePath, document, token) {
                    const packageDependencies = MavenXmlFactory.createDependenciesFromXml(document.getText(), this.config.dependencyProperties);
                    if (packageDependencies.length === 0)
                        return null;
                    // gets source feeds from the project path
                    const promisedRepos = this.mvnClient.fetchRepositories(packagePath);
                    return promisedRepos.then(repos => {
                        const repositories = repos.filter(repo => repo.protocol === clients_29.UrlHelpers.RegistryProtocols.https);
                        const includePrereleases = this.extension.state.prereleasesEnabled.value;
                        const clientData = { repositories };
                        const clientContext = {
                            includePrereleases,
                            clientData,
                        };
                        return packages_22.RequestFactory.executeDependencyRequests(packagePath, this.mavenClient, packageDependencies, clientContext);
                    });
                }
            };
            exports_114("MavenVersionLensProvider", MavenVersionLensProvider);
        }
    };
});
System.register("infrastructure/providers/maven/activate", ["infrastructure/providers/maven/mavenProvider", "infrastructure/providers/maven/mavenConfig"], function (exports_115, context_115) {
    "use strict";
    var mavenProvider_1, mavenConfig_1;
    var __moduleName = context_115 && context_115.id;
    function activate(extension, logger) {
        const config = new mavenConfig_1.MavenConfig(extension);
        return new mavenProvider_1.MavenVersionLensProvider(config, logger);
    }
    exports_115("activate", activate);
    return {
        setters: [
            function (mavenProvider_1_1) {
                mavenProvider_1 = mavenProvider_1_1;
            },
            function (mavenConfig_1_1) {
                mavenConfig_1 = mavenConfig_1_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/npm/activate", ["infrastructure/providers/npm/npmProvider", "infrastructure/providers/npm/npmConfig"], function (exports_116, context_116) {
    "use strict";
    var npmProvider_2, npmConfig_2;
    var __moduleName = context_116 && context_116.id;
    function activate(extension, logger) {
        const config = new npmConfig_2.NpmConfig(extension);
        return new npmProvider_2.NpmVersionLensProvider(config, logger);
    }
    exports_116("activate", activate);
    return {
        setters: [
            function (npmProvider_2_1) {
                npmProvider_2 = npmProvider_2_1;
            },
            function (npmConfig_2_1) {
                npmConfig_2 = npmConfig_2_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/pub/pubConfig", ["core/clients", "presentation/providers"], function (exports_117, context_117) {
    "use strict";
    var clients_30, providers_15, PubContributions, PubConfig;
    var __moduleName = context_117 && context_117.id;
    return {
        setters: [
            function (clients_30_1) {
                clients_30 = clients_30_1;
            },
            function (providers_15_1) {
                providers_15 = providers_15_1;
            }
        ],
        execute: function () {
            (function (PubContributions) {
                PubContributions["Caching"] = "pub.caching";
                PubContributions["Http"] = "pub.http";
                PubContributions["DependencyProperties"] = "pub.dependencyProperties";
                PubContributions["ApiUrl"] = "pub.apiUrl";
            })(PubContributions || (PubContributions = {}));
            PubConfig = class PubConfig extends providers_15.AbstractProviderConfig {
                constructor(extension) {
                    super(extension);
                    this.options = {
                        providerName: 'pub',
                        supports: [
                            providers_15.ProviderSupport.Releases,
                            providers_15.ProviderSupport.Prereleases,
                        ],
                        selector: {
                            language: "yaml",
                            scheme: "file",
                            pattern: "**/pubspec.yaml",
                        }
                    };
                    this.caching = new clients_30.CachingOptions(extension.config, PubContributions.Caching, 'caching');
                    this.http = new clients_30.HttpOptions(extension.config, PubContributions.Http, 'http');
                }
                get dependencyProperties() {
                    return this.extension.config.get(PubContributions.DependencyProperties);
                }
                get apiUrl() {
                    return this.extension.config.get(PubContributions.ApiUrl);
                }
            };
            exports_117("PubConfig", PubConfig);
        }
    };
});
System.register("infrastructure/providers/pub/pubClient", ["core/packages", "core/clients", "infrastructure/clients"], function (exports_118, context_118) {
    "use strict";
    var packages_23, clients_31, clients_32, PubClient;
    var __moduleName = context_118 && context_118.id;
    async function createRemotePackageDocument(client, url, request, semverSpec) {
        return client.requestJson(clients_31.HttpClientRequestMethods.get, url, {})
            .then(function (httpResponse) {
            const packageInfo = httpResponse.data;
            const { providerName } = request;
            const versionRange = semverSpec.rawVersion;
            const requested = request.package;
            const resolved = {
                name: requested.name,
                version: versionRange,
            };
            const response = {
                source: httpResponse.source,
                status: httpResponse.status,
            };
            const rawVersions = packages_23.VersionHelpers.extractVersionsFromMap(packageInfo.versions);
            // seperate versions to releases and prereleases
            const { releases, prereleases } = packages_23.VersionHelpers.splitReleasesFromArray(rawVersions);
            // analyse suggestions
            const suggestions = packages_23.SuggestionFactory.createSuggestionTags(versionRange, releases, prereleases);
            // return PackageDocument
            return {
                providerName,
                source: packages_23.PackageSourceTypes.Registry,
                response,
                type: semverSpec.type,
                requested,
                resolved,
                suggestions,
            };
        });
    }
    return {
        setters: [
            function (packages_23_1) {
                packages_23 = packages_23_1;
            },
            function (clients_31_1) {
                clients_31 = clients_31_1;
            },
            function (clients_32_1) {
                clients_32 = clients_32_1;
            }
        ],
        execute: function () {
            PubClient = class PubClient extends clients_32.JsonHttpClientRequest {
                constructor(config, options, logger) {
                    super(logger, options, {});
                    this.config = config;
                }
                async fetchPackage(request) {
                    const semverSpec = packages_23.VersionHelpers.parseSemver(request.package.version);
                    const url = `${this.config.apiUrl}/api/documentation/${request.package.name}`;
                    return createRemotePackageDocument(this, url, request, semverSpec)
                        .catch((error) => {
                        if (error.status === 404) {
                            return packages_23.DocumentFactory.createNotFound(request.providerName, request.package, null, packages_23.ResponseFactory.createResponseStatus(error.source, error.status));
                        }
                        return Promise.reject(error);
                    });
                }
            };
            exports_118("PubClient", PubClient);
        }
    };
});
System.register("infrastructure/providers/pub/pubUtils", ["presentation/providers"], function (exports_119, context_119) {
    "use strict";
    var providers_16;
    var __moduleName = context_119 && context_119.id;
    function pubReplaceVersion(packageInfo, newVersion) {
        const charAt = this.substr(packageInfo.versionRange.start, 1);
        return providers_16.defaultReplaceFn(packageInfo, 
        // handle cases with blank entries and # comments
        charAt === '#' ?
            newVersion + ' ' :
            newVersion);
    }
    exports_119("pubReplaceVersion", pubReplaceVersion);
    return {
        setters: [
            function (providers_16_1) {
                providers_16 = providers_16_1;
            }
        ],
        execute: function () {
        }
    };
});
System.register("infrastructure/providers/pub/pubProvider", ["core/packages", "presentation/providers", "infrastructure/providers/pub/pubClient", "infrastructure/providers/pub/pubUtils"], function (exports_120, context_120) {
    "use strict";
    var packages_24, providers_17, pubClient_1, pubUtils_1, PubVersionLensProvider;
    var __moduleName = context_120 && context_120.id;
    return {
        setters: [
            function (packages_24_1) {
                packages_24 = packages_24_1;
            },
            function (providers_17_1) {
                providers_17 = providers_17_1;
            },
            function (pubClient_1_1) {
                pubClient_1 = pubClient_1_1;
            },
            function (pubUtils_1_1) {
                pubUtils_1 = pubUtils_1_1;
            }
        ],
        execute: function () {
            PubVersionLensProvider = class PubVersionLensProvider extends providers_17.AbstractVersionLensProvider {
                constructor(config, logger) {
                    super(config, logger);
                    const requestOptions = {
                        caching: config.caching,
                        http: config.http
                    };
                    this.pubClient = new pubClient_1.PubClient(config, requestOptions, logger.child({ namespace: 'pub pkg client' }));
                }
                async fetchVersionLenses(packagePath, document, token) {
                    const yamlText = document.getText();
                    const packageDependencies = packages_24.extractPackageDependenciesFromYaml(yamlText, this.config.dependencyProperties);
                    if (packageDependencies.length === 0)
                        return null;
                    const includePrereleases = this.extension.state.prereleasesEnabled.value;
                    const context = {
                        includePrereleases,
                        clientData: null,
                    };
                    this.customReplaceFn = pubUtils_1.pubReplaceVersion.bind(yamlText);
                    return packages_24.RequestFactory.executeDependencyRequests(packagePath, this.pubClient, packageDependencies, context);
                }
                async updateOutdated(packagePath) {
                    return Promise.resolve();
                }
            };
            exports_120("PubVersionLensProvider", PubVersionLensProvider);
        }
    };
});
System.register("infrastructure/providers/pub/activate", ["infrastructure/providers/pub/pubProvider", "infrastructure/providers/pub/pubConfig"], function (exports_121, context_121) {
    "use strict";
    var pubProvider_1, pubConfig_1;
    var __moduleName = context_121 && context_121.id;
    function activate(extension, logger) {
        const config = new pubConfig_1.PubConfig(extension);
        return new pubProvider_1.PubVersionLensProvider(config, logger);
    }
    exports_121("activate", activate);
    return {
        setters: [
            function (pubProvider_1_1) {
                pubProvider_1 = pubProvider_1_1;
            },
            function (pubConfig_1_1) {
                pubConfig_1 = pubConfig_1_1;
            }
        ],
        execute: function () {
        }
    };
});
//# sourceMappingURL=extension-bundle.js.map