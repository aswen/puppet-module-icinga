# == Class: icinga::server::configs
#
# Manages the Icinga server configuration
#
# === Authors
#
# Nedap Steppingstone <steppingstone@nedap.com>
#
# === Copyright
#
# Copyright 2012, 2013 Nedap Steppingstone.
#
class icinga::server::configs (
  $d_icinga                   = $::icinga::server::dir_icinga,
  $d_objects                  = $::icinga::server::dir_objects,
  $d_modules                  = $::icinga::server::dir_modules,
  $object_dirs                = $::icinga::server::object_dirs,
  $d_htdocs                   = $::icinga::server::dir_htdocs,
  $d_cgi                      = $::icinga::server::dir_cgi,
  $d_stylesheets              = $::icinga::server::dir_stylesheets,
  $f_htpasswd                 = $::icinga::server::file_htpasswd,
  $f_icingacfg                = $::icinga::server::file_icingacfg,
  $f_resourcecfg              = $::icinga::server::file_resourcecfg,
  $f_cgicfg                   = $::icinga::server::file_cgicfg,
  $d_icinga_plugins           = $::icinga::server::dir_icinga_plugins,
  $d_nagios_plugins           = $::icinga::server::dir_nagios_plugins,
  $d_icinga_eventhandlers     = $::icinga::server::dir_icinga_eventhandlers,
  $d_icinga_cache             = $::icinga::server::dir_icinga_cache,
  $enable_notifications       = $::icinga::server::enable_notifications,
  $icinga_configure_webserver = $::icinga::server::icinga_configure_webserver,
  $icinga_vhostname           = $::icinga::server::icinga_vhostname,
  $icinga_webserver           = $::icinga::server::icinga_webserver,
  $icinga_webserver_port      = $::icinga::server::icinga_webserver_port,
  $d_webserver_log            = $::icinga::server::dir_webserver_log,
  $webserver_user             = $::icinga::server::webserver_user,
  $webserver_group            = $::icinga::server::webserver_group,
  # following is used to configure icinga.cfg
  $icinga_logfile                              = $::icinga::server::icinga_logfile,
  $dir_nagios_plugins_config                   = $::icinga::server::dir_nagios_plugins_config,
  $object_cache_file                           = $::icinga::server::object_cache_file,
  $precached_object_file                       = $::icinga::server::precached_object_file,
  $status_file                                 = $::icinga::server::status_file,
  $status_update_interval                      = $::icinga::server::status_update_interval,
  $icinga_user                                 = $::icinga::server::icinga_user,
  $icinga_group                                = $::icinga::server::icinga_group,
  $check_external_commands                     = $::icinga::server::check_external_commands,
  $command_check_interval                      = $::icinga::server::command_check_interval,
  $command_file                                = $::icinga::server::command_file,
  $external_command_buffer_slots               = $::icinga::server::external_command_buffer_slots,
  $lock_file                                   = $::icinga::server::lock_file,
  $temp_file                                   = $::icinga::server::temp_file,
  $temp_path                                   = $::icinga::server::temp_path,
  $event_broker_options                        = $::icinga::server::event_broker_options,
  $broker_module                               = $::icinga::server::broker_module,
  $log_rotation_method                         = $::icinga::server::log_rotation_method,
  $log_archive_path                            = $::icinga::server::log_archive_path,
  $use_daemon_log                              = $::icinga::server::use_daemon_log,
  $use_syslog                                  = $::icinga::server::use_syslog,
  $use_syslog_local_facility                   = $::icinga::server::use_syslog_local_facility,
  $syslog_local_facility                       = $::icinga::server::syslog_local_facility,
  $log_notifications                           = $::icinga::server::log_notifications,
  $log_service_retries                         = $::icinga::server::log_service_retries,
  $log_host_retries                            = $::icinga::server::log_host_retries,
  $log_event_handlers                          = $::icinga::server::log_event_handlers,
  $log_initial_states                          = $::icinga::server::log_initial_states,
  $log_current_states                          = $::icinga::server::log_current_states,
  $log_external_commands                       = $::icinga::server::log_external_commands,
  $log_passive_checks                          = $::icinga::server::log_passive_checks,
  $log_long_plugin_output                      = $::icinga::server::log_long_plugin_output,
  $global_host_event_handler                   = $::icinga::server::global_host_event_handler,
  $global_service_event_handler                = $::icinga::server::global_service_event_handler,
  $service_inter_check_delay_method            = $::icinga::server::service_inter_check_delay_method,
  $max_service_check_spread                    = $::icinga::server::max_service_check_spread,
  $service_interleave_factor                   = $::icinga::server::service_interleave_factor,
  $host_inter_check_delay_method               = $::icinga::server::host_inter_check_delay_method,
  $max_host_check_spread                       = $::icinga::server::max_host_check_spread,
  $max_concurrent_checks                       = $::icinga::server::max_concurrent_checks,
  $check_result_reaper_frequency               = $::icinga::server::check_result_reaper_frequency,
  $max_check_result_reaper_time                = $::icinga::server::max_check_result_reaper_time,
  $check_result_path                           = $::icinga::server::check_result_path,
  $max_check_result_file_age                   = $::icinga::server::max_check_result_file_age,
  $max_check_result_list_items                 = $::icinga::server::max_check_result_list_items,
  $cached_host_check_horizon                   = $::icinga::server::cached_host_check_horizon,
  $cached_service_check_horizon                = $::icinga::server::cached_service_check_horizon,
  $enable_predictive_host_dependency_checks    = $::icinga::server::enable_predictive_host_dependency_checks,
  $enable_predictive_service_dependency_checks = $::icinga::server::enable_predictive_service_dependency_checks,
  $soft_state_dependencies                     = $::icinga::server::soft_state_dependencies,
  $time_change_threshold                       = $::icinga::server::time_change_threshold,
  $auto_reschedule_checks                      = $::icinga::server::auto_reschedule_checks,
  $auto_rescheduling_interval                  = $::icinga::server::auto_rescheduling_interval,
  $auto_rescheduling_window                    = $::icinga::server::auto_rescheduling_window,
  $sleep_time                                  = $::icinga::server::sleep_time,
  $service_check_timeout                       = $::icinga::server::service_check_timeout,
  $host_check_timeout                          = $::icinga::server::host_check_timeout,
  $event_handler_timeout                       = $::icinga::server::event_handler_timeout,
  $notification_timeout                        = $::icinga::server::notification_timeout,
  $ocsp_timeout                                = $::icinga::server::ocsp_timeout,
  $perfdata_timeout                            = $::icinga::server::perfdata_timeout,
  $retain_state_information                    = $::icinga::server::retain_state_information,
  $state_retention_file                        = $::icinga::server::state_retention_file,
  $sync_retention_file                         = $::icinga::server::sync_retention_file,
  $retention_update_interval                   = $::icinga::server::retention_update_interval,
  $use_retained_program_state                  = $::icinga::server::use_retained_program_state,
  $use_retained_scheduling_info                = $::icinga::server::use_retained_scheduling_info,
  $retained_host_attribute_mask                = $::icinga::server::retained_host_attribute_mask,
  $retained_service_attribute_mask             = $::icinga::server::retained_service_attribute_mask,
  $retained_process_host_attribute_mask        = $::icinga::server::retained_process_host_attribute_mask,
  $retained_process_service_attribute_mask     = $::icinga::server::retained_process_service_attribute_mask,
  $retained_contact_host_attribute_mask        = $::icinga::server::retained_contact_host_attribute_mask,
  $retained_contact_service_attribute_mask     = $::icinga::server::retained_contact_service_attribute_mask,
  $interval_length                             = $::icinga::server::interval_length,
  $check_for_updates                           = $::icinga::server::check_for_updates,
  $bare_update_check                           = $::icinga::server::bare_update_check,
  $use_aggressive_host_checking                = $::icinga::server::use_aggressive_host_checking,
  $execute_service_checks                      = $::icinga::server::execute_service_checks,
  $accept_passive_service_checks               = $::icinga::server::accept_passive_service_checks,
  $execute_host_checks                         = $::icinga::server::execute_host_checks,
  $accept_passive_host_checks                  = $::icinga::server::accept_passive_host_checks,
  $enable_event_handlers                       = $::icinga::server::enable_event_handlers,
  $process_performance_data                    = $::icinga::server::process_performance_data,
  $host_perfdata_command                       = $::icinga::server::host_perfdata_command,
  $service_perfdata_command                    = $::icinga::server::service_perfdata_command,
  $host_perfdata_file                          = $::icinga::server::host_perfdata_file,
  $service_perfdata_file                       = $::icinga::server::service_perfdata_file,
  $host_perfdata_file_template                 = $::icinga::server::host_perfdata_file_template,
  $service_perfdata_file_template              = $::icinga::server::service_perfdata_file_template,
  $host_perfdata_file_mode                     = $::icinga::server::host_perfdata_file_mode,
  $service_perfdata_file_mode                  = $::icinga::server::service_perfdata_file_mode,
  $host_perfdata_file_processing_interval      = $::icinga::server::host_perfdata_file_processing_interval,
  $service_perfdata_file_processing_interval   = $::icinga::server::service_perfdata_file_processing_interval,
  $host_perfdata_file_processing_command       = $::icinga::server::host_perfdata_file_processing_command,
  $service_perfdata_file_processing_command    = $::icinga::server::service_perfdata_file_processing_command,
  $host_perfdata_process_empty_results         = $::icinga::server::host_perfdata_process_empty_results,
  $service_perfdata_process_empty_results      = $::icinga::server::service_perfdata_process_empty_results,
  $allow_empty_hostgroup_assignment            = $::icinga::server::allow_empty_hostgroup_assignment,
  $obsess_over_services                        = $::icinga::server::obsess_over_services,
  $ocsp_command                                = $::icinga::server::ocsp_command,
  $obsess_over_hosts                           = $::icinga::server::obsess_over_hosts,
  $ochp_command                                = $::icinga::server::ochp_command,
  $translate_passive_host_checks               = $::icinga::server::translate_passive_host_checks,
  $passive_host_checks_are_soft                = $::icinga::server::passive_host_checks_are_soft,
  $check_for_orphaned_services                 = $::icinga::server::check_for_orphaned_services,
  $check_for_orphaned_hosts                    = $::icinga::server::check_for_orphaned_hosts,
  $service_check_timeout_state                 = $::icinga::server::service_check_timeout_state,
  $check_service_freshness                     = $::icinga::server::check_service_freshness,
  $service_freshness_check_interval            = $::icinga::server::service_freshness_check_interval,
  $check_host_freshness                        = $::icinga::server::check_host_freshness,
  $host_freshness_check_interval               = $::icinga::server::host_freshness_check_interval,
  $additional_freshness_latency                = $::icinga::server::additional_freshness_latency,
  $enable_flap_detection                       = $::icinga::server::enable_flap_detection,
  $low_service_flap_threshold                  = $::icinga::server::low_service_flap_threshold,
  $high_service_flap_threshold                 = $::icinga::server::high_service_flap_threshold,
  $low_host_flap_threshold                     = $::icinga::server::low_host_flap_threshold,
  $high_host_flap_threshold                    = $::icinga::server::high_host_flap_threshold,
  $date_format                                 = $::icinga::server::date_format,
  $p1_file                                     = $::icinga::server::p1_file,
  $enable_embedded_perl                        = $::icinga::server::enable_embedded_perl,
  $use_embedded_perl_implicitly                = $::icinga::server::use_embedded_perl_implicitly,
  $stalking_event_handlers_for_hosts           = $::icinga::server::stalking_event_handlers_for_hosts,
  $stalking_event_handlers_for_services        = $::icinga::server::stalking_event_handlers_for_services,
  $stalking_notifications_for_hosts            = $::icinga::server::stalking_notifications_for_hosts,
  $stalking_notifications_for_services         = $::icinga::server::stalking_notifications_for_services,
  $illegal_object_name_chars                   = $::icinga::server::illegal_object_name_chars,
  $illegal_macro_output_chars                  = $::icinga::server::illegal_macro_output_chars,
  $use_regexp_matching                         = $::icinga::server::use_regexp_matching,
  $use_true_regexp_matching                    = $::icinga::server::use_true_regexp_matching,
  $admin_email                                 = $::icinga::server::admin_email,
  $admin_pager                                 = $::icinga::server::admin_pager,
  $daemon_dumps_core                           = $::icinga::server::daemon_dumps_core,
  $use_large_installation_tweaks               = $::icinga::server::use_large_installation_tweaks,
  $enable_environment_macros                   = $::icinga::server::enable_environment_macros,
  $free_child_process_memory                   = $::icinga::server::free_child_process_memory,
  $child_processes_fork_twice                  = $::icinga::server::child_processes_fork_twice,
  $debug_level                                 = $::icinga::server::debug_level,
  $debug_verbosity                             = $::icinga::server::debug_verbosity,
  $debug_file                                  = $::icinga::server::debug_file,
  $max_debug_file_size                         = $::icinga::server::max_debug_file_size,
  # This is not deprecated in 1.9 and generates a warning in 1.10. Therefor
  # it will be undef (it originally was 0)
  $event_profiling_enabled                     = $::icinga::server::event_profiling_enabled,

  # Following is to configure cgi.cfg
  $main_config_file                                      = $::icinga::server::main_config_file,
  $authorization_config_file                             = $::icinga::server::authorization_config_file,
  $standalone_installation                               = $::icinga::server::standalone_installation,
  $physical_html_path                                    = $::icinga::server::physical_html_path,
  $url_html_path                                         = $::icinga::server::url_html_path,
  $url_stylesheets_path                                  = $::icinga::server::url_stylesheets_path,
  $http_charset                                          = $::icinga::server::http_charset,
  $show_context_help                                     = $::icinga::server::show_context_help,
  $highlight_table_rows                                  = $::icinga::server::highlight_table_rows,
  $use_pending_states                                    = $::icinga::server::use_pending_states,
  $use_logging                                           = $::icinga::server::use_logging,
  $cgi_log_file                                          = $::icinga::server::cgi_log_file,
  $cgi_log_rotation_method                               = $::icinga::server::cgi_log_rotation_method,
  $cgi_log_archive_path                                  = $::icinga::server::cgi_log_archive_path,
  $enforce_comments_on_actions                           = $::icinga::server::enforce_comments_on_actions,
  $send_ack_notifications                                = $::icinga::server::send_ack_notifications,
  $first_day_of_week                                     = $::icinga::server::first_day_of_week,
  $icinga_check_command                                  = $::icinga::server::icinga_check_command,
  $use_authentication                                    = $::icinga::server::use_authentication,
  $use_ssl_authentication                                = $::icinga::server::use_ssl_authentication,
  $default_user_name                                     = $::icinga::server::default_user_name,
  $authorized_for_system_information                     = $::icinga::server::authorized_for_system_information,
  $authorized_contactgroup_for_system_information        = $::icinga::server::authorized_contactgroup_for_system_information,
  $authorized_for_configuration_information              = $::icinga::server::authorized_for_configuration_information,
  $authorized_contactgroup_for_configuration_information = $::icinga::server::authorized_contactgroup_for_configuration_information,
  $authorized_for_full_command_resolution                = $::icinga::server::authorized_for_full_command_resolution,
  $authorized_contactgroup_for_full_command_resolution   = $::icinga::server::authorized_contactgroup_for_full_command_resolution,
  $authorized_for_system_commands                        = $::icinga::server::authorized_for_system_commands,
  $authorized_contactgroup_for_system_commands           = $::icinga::server::authorized_contactgroup_for_system_commands,
  $authorized_for_all_services                           = $::icinga::server::authorized_for_all_services,
  $authorized_for_all_hosts                              = $::icinga::server::authorized_for_all_hosts,
  $authorized_contactgroup_for_all_services              = $::icinga::server::authorized_contactgroup_for_all_services,
  $authorized_contactgroup_for_all_hosts                 = $::icinga::server::authorized_contactgroup_for_all_hosts,
  $authorized_for_all_service_commands                   = $::icinga::server::authorized_for_all_service_commands,
  $authorized_for_all_host_commands                      = $::icinga::server::authorized_for_all_host_commands,
  $authorized_contactgroup_for_all_service_commands      = $::icinga::server::authorized_contactgroup_for_all_service_commands,
  $authorized_contactgroup_for_all_host_commands         = $::icinga::server::authorized_contactgroup_for_all_host_commands,
  $authorized_for_read_only                              = $::icinga::server::authorized_for_read_only,
  $authorized_contactgroup_for_read_only                 = $::icinga::server::authorized_contactgroup_for_read_only,
  $show_all_services_host_is_authorized_for              = $::icinga::server::show_all_services_host_is_authorized_for,
  $show_partial_hostgroups                               = $::icinga::server::show_partial_hostgroups,
  $statusmap_background_image                            = $::icinga::server::statusmap_background_image,
  $color_transparency_index_r                            = $::icinga::server::color_transparency_index_r,
  $color_transparency_index_g                            = $::icinga::server::color_transparency_index_g,
  $color_transparency_index_b                            = $::icinga::server::color_transparency_index_b,
  $default_statusmap_layout                              = $::icinga::server::default_statusmap_layout,
  $refresh_type                                          = $::icinga::server::refresh_type,
  $default_statuswrl_layout                              = $::icinga::server::default_statuswrl_layout,
  $persistent_ack_comments                               = $::icinga::server::persistent_ack_comments,
  $statuswrl_include                                     = $::icinga::server::statuswrl_include,
  $ping_syntax                                           = $::icinga::server::ping_syntax,
  $refresh_rate                                          = $::icinga::server::refresh_rate,
  $escape_html_tags                                      = $::icinga::server::escape_html_tags,
  $result_limit                                          = $::icinga::server::result_limit,
  $host_unreachable_sound                                = $::icinga::server::host_unreachable_sound,
  $host_down_sound                                       = $::icinga::server::host_down_sound,
  $service_critical_sound                                = $::icinga::server::service_critical_sound,
  $service_warning_sound                                 = $::icinga::server::service_warning_sound,
  $service_unknown_sound                                 = $::icinga::server::service_unknown_sound,
  $normal_sound                                          = $::icinga::server::normal_sound,
  $action_url_target                                     = $::icinga::server::action_url_target,
  $notes_url_target                                      = $::icinga::server::notes_url_target,
  $lock_author_names                                     = $::icinga::server::lock_author_names,
  $default_downtime_duration                             = $::icinga::server::default_downtime_duration,
  $set_expire_ack_by_default                             = $::icinga::server::set_expire_ack_by_default,
  $default_expiring_acknowledgement_duration             = $::icinga::server::default_expiring_acknowledgement_duration,
  $status_show_long_plugin_output                        = $::icinga::server::status_show_long_plugin_output,
  $display_status_totals                                 = $::icinga::server::display_status_totals,
  $tac_show_only_hard_state                              = $::icinga::server::tac_show_only_hard_state,
  $extinfo_show_child_hosts                              = $::icinga::server::extinfo_show_child_hosts,
  $suppress_maintenance_downtime                         = $::icinga::server::suppress_maintenance_downtime,
  $show_tac_header                                       = $::icinga::server::show_tac_header,
  $show_tac_header_pending                               = $::icinga::server::show_tac_header_pending,
  $exclude_customvar_name                                = $::icinga::server::exclude_customvar_name,
  $exclude_customvar_value                               = $::icinga::server::exclude_customvar_value,
  $showlog_initial_states                                = $::icinga::server::showlog_initial_states,
  $showlog_current_states                                = $::icinga::server::showlog_current_states,
  $default_num_displayed_log_entries                     = $::icinga::server::default_num_displayed_log_entries,
  $csv_delimiter                                         = $::icinga::server::csv_delimiter,
  $csv_data_enclosure                                    = $::icinga::server::csv_data_enclosure,
  $tab_friendly_titles                                   = $::icinga::server::tab_friendly_titles,
  $add_notif_num_hard                                    = $::icinga::server::add_notif_num_hard,
  $add_notif_num_soft                                    = $::icinga::server::add_notif_num_soft,
  $enable_splunk_integration                             = $::icinga::server::enable_splunk_integration,
  $splunk_url                                            = $::icinga::server::splunk_url,
  $resource_file                                         = $::icinga::server::resource_file,
  $log_file                                              = $::icinga::server::log_file,
) {

  file { $d_icinga:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Class['icinga::server::services'],
  }

  file { $d_stylesheets:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
  }

  file { $f_icingacfg:
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('icinga/server/icinga.cfg.erb'),
    notify  => Class['icinga::server::services'],
  }

  file { $f_cgicfg:
    mode    => '0644',
    owner   => root,
    group   => root,
    content => template('icinga/server/cgi.cfg.erb'),
    notify  => Class['icinga::server::services'],
  }

  file { $d_objects:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Class['icinga::server::services'],
  }

  file { $d_icinga_cache:
    ensure  => directory,
    mode    => '2750',
    owner   => $icinga_user,
    group   => $webserver_group,
  }

  file { $d_modules:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Class['icinga::server::services'],
  }

  file { $d_icinga_plugins:
    ensure  => directory,
    mode    => '0755',
    owner   => root,
    group   => root,
    recurse => true,
    purge   => true,
    force   => true,
    notify  => Class['icinga::server::services'],
  }

  # resource.cfg file
  concat_build { 'icinga_resourceconf':
    order => ['*.conf'],
  }

  # uses:
  # user1 d_nagios_plugins
  # user2 d_icinga_plugins
  # user3 d_icinga_eventhandlers
  concat_fragment { 'icinga_resourceconf+001-start.conf':
    content => template('icinga/server/resource.cfg.erb'),
  }

  file { $f_resourcecfg:
    mode    => '0600',
    owner   => $icinga_user,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_resourceconf'],
    source  => concat_output('icinga_resourceconf'),
  } # end resource.cfg file

  # htpasswd file
  concat_build { 'icinga_htpasswd':
    order => ['*.conf'],
  }

  concat_fragment { 'icinga_htpasswd+001-start.conf':
    content => "# This file is maintained by Puppet.\n",
  }

  file { $f_htpasswd:
    mode    => '0644',
    owner   => root,
    group   => root,
    require => Concat_build['icinga_htpasswd'],
    source  => concat_output('icinga_htpasswd'),
  } # end htpasswd file

  if $icinga_configure_webserver == true {

    # be aware that you have to create a link to this file in the sites-enabled
    # dir of the webserver yourself.
    file { "${d_icinga}/${icinga_vhostname}-${icinga_webserver}.conf.example":
      mode    => '0644',
      owner   => root,
      group   => root,
      content => template("icinga/server/vhost_${icinga_webserver}.conf.erb"),
    }

  } # end webserver

  # if external commands are enabled some defaults should be changed:
  if $check_external_commands == 1 {

    if $::operatingsystem == 'Debian' {

      exec { 'dpkg-icinga-override /var/lib/icinga':
        command => "dpkg-statoverride --update --add ${icinga_user} ${icinga_group} 751 /var/lib/icinga",
        unless  => "dpkg-statoverride --list ${icinga_user} ${icinga_group} 751 /var/lib/icinga",
        path    => '/usr/sbin',
        notify  => Class['icinga::server::services'],
      }

      exec { 'dpkg-icinga-override /var/lib/icinga/rw':
        command => "dpkg-statoverride --update --add ${icinga_user} ${webserver_group} 2710 /var/lib/icinga/rw",
        unless  => "dpkg-statoverride --list ${icinga_user} ${webserver_group} 2710 /var/lib/icinga/rw",
        path    => '/usr/sbin',
        notify  => Class['icinga::server::services'],
      }

    } #if operating system

  } # if check external commands

  # objects files
  concat_build { 'icinga_command':
    order => ['*.cfg'],
  }
  file { "${d_objects}/command.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_command'],
    source  => concat_output('icinga_command'),
  }
  concat_fragment { 'icinga_command+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_contact':
    order => ['*.cfg'],
  }
  file { "${d_objects}/contact.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_contact'],
    source  => concat_output('icinga_contact'),
  }
  concat_fragment { 'icinga_contact+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_contactgroup':
    order => ['*.cfg'],
  }
  file { "${d_objects}/contactgroup.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_contactgroup'],
    source  => concat_output('icinga_contactgroup'),
  }
  concat_fragment { 'icinga_contactgroup+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_host':
    order => ['*.cfg'],
  }
  file { "${d_objects}/host.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_host'],
    source  => concat_output('icinga_host'),
  }
  concat_fragment { 'icinga_host+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_hostdependency':
    order => ['*.cfg'],
  }
  file { "${d_objects}/hostdependency.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_hostdependency'],
    source  => concat_output('icinga_hostdependency'),
  }
  concat_fragment { 'icinga_hostdependency+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_hostescalation':
    order => ['*.cfg'],
  }
  file { "${d_objects}/hostescalation.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_hostescalation'],
    source  => concat_output('icinga_hostescalation'),
  }
  concat_fragment { 'icinga_hostescalation+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_hostextinfo':
    order => ['*.cfg'],
  }
  file { "${d_objects}/hostextinfo.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_hostextinfo'],
    source  => concat_output('icinga_hostextinfo'),
  }
  concat_fragment { 'icinga_hostextinfo+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_hostgroup':
    order => ['*.cfg'],
  }
  file { "${d_objects}/hostgroup.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_hostgroup'],
    source  => concat_output('icinga_hostgroup'),
  }
  concat_fragment { 'icinga_hostgroup+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_module':
    order => ['*.cfg'],
  }
  file { "${d_objects}/module.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_module'],
    source  => concat_output('icinga_module'),
  }
  concat_fragment { 'icinga_module+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_service':
    order => ['*.cfg'],
  }
  file { "${d_objects}/service.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_service'],
    source  => concat_output('icinga_service'),
  }
  concat_fragment { 'icinga_service+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_servicedependency':
    order => ['*.cfg'],
  }
  file { "${d_objects}/servicedependency.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_servicedependency'],
    source  => concat_output('icinga_servicedependency'),
  }
  concat_fragment { 'icinga_servicedependency+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_serviceescalation':
    order => ['*.cfg'],
  }
  file { "${d_objects}/serviceescalation.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_serviceescalation'],
    source  => concat_output('icinga_serviceescalation'),
  }
  concat_fragment { 'icinga_serviceescalation+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_serviceextinfo':
    order => ['*.cfg'],
  }
  file { "${d_objects}/serviceextinfo.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_serviceextinfo'],
    source  => concat_output('icinga_serviceextinfo'),
  }
  concat_fragment { 'icinga_serviceextinfo+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_servicegroup':
    order => ['*.cfg'],
  }
  file { "${d_objects}/servicegroup.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_servicegroup'],
    source  => concat_output('icinga_servicegroup'),
  }
  concat_fragment { 'icinga_servicegroup+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  concat_build { 'icinga_timeperiod':
    order => ['*.cfg'],
  }
  file { "${d_objects}/timeperiod.cfg":
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => Class['icinga::server::services'],
    require => Concat_build['icinga_timeperiod'],
    source  => concat_output('icinga_timeperiod'),
  }
  concat_fragment { 'icinga_timeperiod+001-start.cfg':
    content => "# This file is maintained by Puppet.\n",
  }

  Icinga::Resource <||>
  Icinga::Resource <<||>>
}
