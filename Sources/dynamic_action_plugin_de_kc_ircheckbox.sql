prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>68902856794577361
,p_default_application_id=>21000
,p_default_owner=>'Sample'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/de_kc_ircheckbox
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(224405160840830550)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'DE.KC.IRCHECKBOX'
,p_display_name=>'IR Checkbox'
,p_category=>'COMPONENT'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#apex_kc_utils#MIN#.js',
'#PLUGIN_FILES#apex_ir_checkbox#MIN#.js',
'',
''))
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'FUNCTION printattributes ',
'( ',
'   p_dynamic_action_render_result   IN apex_plugin.t_dynamic_action_render_result ',
') ',
'   RETURN CLOB ',
'IS ',
'BEGIN ',
'   apex_json.initialize_clob_output; ',
' ',
'   apex_json.open_object; ',
'   apex_json.write (''type'', ''apex_plugin.t_dynamic_action_render_result''); ',
' ',
'   apex_json.write (''javascript_function'', ',
'                    p_dynamic_action_render_result.javascript_function); ',
'   apex_json.write (''ajax_identifier'', p_dynamic_action_render_result.ajax_identifier); ',
'   apex_json.write (''attribute_01'', p_dynamic_action_render_result.attribute_01); ',
'   apex_json.write (''attribute_02'', p_dynamic_action_render_result.attribute_02); ',
' ',
'   apex_json.close_object; ',
' ',
'   RETURN apex_json.get_clob_output; ',
'END printattributes; ',
' ',
' ',
'------------------------ ',
' ',
'FUNCTION printattributes (p_plugin IN apex_plugin.t_plugin) ',
'   RETURN CLOB ',
'IS ',
'BEGIN ',
'   apex_json.initialize_clob_output; ',
' ',
'   apex_json.open_object; ',
'   apex_json.write (''type'', ''apex_plugin.t_plugin''); ',
' ',
'   apex_json.write (''name'', p_plugin.name); ',
'   apex_json.write (''file_prefix'', p_plugin.file_prefix); ',
'   apex_json.write (''attribute_01'', p_plugin.attribute_01); ',
'   apex_json.write (''attribute_02'', p_plugin.attribute_02); ',
' ',
'   apex_json.close_object; ',
' ',
'   RETURN apex_json.get_clob_output; ',
'END printattributes; ',
' ',
'------------------------ ',
' ',
'FUNCTION printattributes (p_dynamic_action IN apex_plugin.t_dynamic_action) ',
'   RETURN CLOB ',
'IS ',
'BEGIN ',
'   apex_json.initialize_clob_output; ',
' ',
'   apex_json.open_object; ',
'   apex_json.write (''type'', ''apex_plugin.t_dynamic_action''); ',
' ',
'   apex_json.write (''id'', ',
'                    p_dynamic_action.id, ',
'                    FALSE); ',
'   apex_json.write (''action'', ',
'                    p_dynamic_action.action, ',
'                    FALSE); ',
'   apex_json.write (''attribute_01'', ',
'                    p_dynamic_action.attribute_01, ',
'                    TRUE); ',
'   apex_json.write (''attribute_02'', ',
'                    p_dynamic_action.attribute_02, ',
'                    TRUE); ',
' ',
'   apex_json.close_object; ',
' ',
'   RETURN apex_json.get_clob_output; ',
'END printattributes; ',
' ',
'FUNCTION render_func ',
'( ',
'   p_dynamic_action   IN apex_plugin.t_dynamic_action, ',
'   p_plugin           IN apex_plugin.t_plugin ',
') ',
'   RETURN apex_plugin.t_dynamic_action_render_result ',
'IS ',
'   l_result             apex_plugin.t_dynamic_action_render_result; ',
' ',
'   l_attr_collec_name           VARCHAR2 (255) := p_dynamic_action.attribute_01; ',
'   l_attr_col_id                VARCHAR2 (100)   := p_dynamic_action.attribute_02; ',
'   l_trunc_coll_on_change_items VARCHAR2 (1)     := p_dynamic_action.attribute_04;',
'   l_items                      VARCHAR2 (32767) := p_dynamic_action.attribute_05;',
'   l_items_vc_arr2              APEX_APPLICATION_GLOBAL.VC_ARR2; ',
'BEGIN ',
'   l_result.ajax_identifier := wwv_flow_plugin.get_ajax_identifier; ',
'   ',
'   APEX_DEBUG.TRACE(p_message => ''Render checboxes DA id = '' || wwv_flow_plugin.get_ajax_identifier);',
'     ',
'   IF l_trunc_coll_on_change_items = ''Y'' THEN ',
'   ',
'       APEX_DEBUG.TRACE(p_message => ''Truncate collection on change of items is enabbled  l_trunc_coll_on_change_items = '' || l_trunc_coll_on_change_items);',
'   ',
'       l_items_vc_arr2 := APEX_UTIL.STRING_TO_TABLE(l_items,'',''); ',
'        ',
'       FOR z IN 1..l_items_vc_arr2.count LOOP',
'         APEX_DEBUG.TRACE(p_message => ''We are settiong onchange attribbute for item = '' || l_items_vc_arr2(z) ||'' to clear collection!'');',
'         apex_javascript.add_inline_code ( ',
'                                            p_code => ''$("#''||l_items_vc_arr2(z)||''")[0].setAttribute("onchange", "apex.kcUtils.irCheckbox.clearCheckedRecordsArrayAjax(''''item'''',this)")'',  ',
'                                            p_key  => ''refresh_collection_widget_function''||l_attr_collec_name||z );',
'         IF z = 1 THEN',
'             l_result.attribute_08 := l_items_vc_arr2(z);',
'         ELSE',
'             l_result.attribute_08 := l_result.attribute_08 || '','' || l_items_vc_arr2(z);',
'         END IF;',
'       END LOOP;     ',
'  END IF;    ',
'   APEX_DEBUG.TRACE(p_message => ''Hooking the pex.kcUtils.irCheckbox.init function to Dynamic Action !'');',
'   l_result.javascript_function := ''apex.kcUtils.irCheckbox.init''; ',
'    ',
'   -- used to be printed in debug console when DEBUG is on ',
'   l_result.attribute_01    := l_attr_collec_name; ',
'   l_result.attribute_02    := l_attr_col_id; ',
'   l_result.attribute_05    := p_dynamic_action.attribute_05; ',
'   l_result.attribute_06    := p_dynamic_action.attribute_06; ',
'   l_result.attribute_07    := p_dynamic_action.attribute_07; ',
'   l_result.attribute_08    := p_dynamic_action.attribute_08; ',
'   l_result.attribute_09    := p_dynamic_action.attribute_09;',
' ',
'   IF apex_application.g_debug THEN ',
'      apex_plugin_util.debug_dynamic_action (p_plugin           => p_plugin, ',
'                                             p_dynamic_action   => p_dynamic_action); ',
'',
'      apex_javascript.add_onload_code ( ',
'            ''  ',
'        apex.debug.info("p_dynamic_action", '' ',
'         || printattributes (p_dynamic_action) ',
'         || '');  ',
'        apex.debug.info("p_plugin",         '' ',
'         || printattributes (p_plugin) ',
'         || '');  ',
'        apex.debug.info("l_result",         '' ',
'         || printattributes (l_result) ',
'         || '');  ',
'      ''); ',
'   END IF; ',
'   APEX_DEBUG.TRACE(p_message => ''END of Rndering function!'');',
'   RETURN l_result; ',
'END render_func; ',
' ',
' ',
'FUNCTION ajax_func ',
'( ',
'   p_dynamic_action   IN apex_plugin.t_dynamic_action, ',
'   p_plugin           IN apex_plugin.t_plugin ',
') ',
'   RETURN apex_plugin.t_dynamic_action_ajax_result ',
'IS ',
'   l_result             apex_plugin.t_dynamic_action_ajax_result; ',
'   l_json_clob          CLOB := apex_application.g_clob_01; ',
'   l_json_values        apex_json.t_values; ',
'   l_count              PLS_INTEGER; ',
'   l_rec_id             VARCHAR2 (4000); ',
'   l_attr_collec_name   VARCHAR2 (255) := p_dynamic_action.attribute_01; ',
'   l_attr_truncate      VARCHAR2 (32767) := p_dynamic_action.attribute_03; ',
'   l_request            VARCHAR2 (100) := apex_application.g_x01; ',
'   l_checkedrecords     CLOB := empty_clob (); ',
'   l_chunk_size         NUMBER := 4000; ',
'   l_error_message      VARCHAR2 (32767);',
'BEGIN ',
'   APEX_DEBUG.TRACE(p_message => ''Ajax function called for DA with id ''||wwv_flow_plugin.get_ajax_identifier||'' with request = ''||l_request||'' !'');',
'   IF l_request = ''RENDER_CHECKBOX'' THEN ',
'   ',
'      ',
'      apex_json.initialize_clob_output;',
'      apex_json.open_array ();',
'         ',
'      IF apex_collection.collection_exists (p_collection_name => l_attr_collec_name) THEN ',
'        APEX_DEBUG.TRACE(p_message => ''Collection "''||l_attr_collec_name||''" existis!'');',
'        IF l_attr_truncate = ''Y'' THEN ',
'           APEX_DEBUG.TRACE(p_message => ''Truncate collection on page load attribute is enabled so we will truncate collection "''||l_attr_collec_name||''" !'');',
'           apex_collection.create_or_truncate_collection ( ',
'             p_collection_name   => l_attr_collec_name); ',
'       ',
'        ELSE',
'         APEX_DEBUG.TRACE(p_message => ''Truncate collection on page load attribute is not enabled so we will return collection "''||l_attr_collec_name||''" members to UI !'');',
'         FOR record IN (SELECT c001 AS id ',
'                          FROM apex_collections ',
'                         WHERE collection_name = l_attr_collec_name) ',
'         LOOP ',
'            APEX_DEBUG.TRACE(p_message => ''Record with id  "''||record.id||''" is returned to UI !'');',
'            apex_json.open_object (); ',
'            apex_json.write (''id'', record.id); ',
'            apex_json.close_object; ',
'         END LOOP; ',
'         ',
'        END IF;',
'        ',
'      END IF; ',
' ',
'      apex_json.close_array; ',
' ',
'      l_checkedrecords := apex_json.get_clob_output; ',
'      ',
'      apex_json.free_output; ',
' ',
'      IF length (l_checkedrecords) > 0 THEN ',
'      ',
'         FOR i IN 0 .. floor (length (l_checkedrecords) / l_chunk_size) ',
'         LOOP ',
'            sys.htp.prn (substr (l_checkedrecords, ',
'                                 i * l_chunk_size + 1, ',
'                                 l_chunk_size)); ',
'         END LOOP; ',
'      ELSE',
'          APEX_DEBUG.TRACE(p_message => ''There are no selected records in the collection "''||l_attr_collec_name||''" to be returned to UI !'');',
'      END IF; ',
'',
'   ELSIF  l_request = ''SUBMIT_CHECKBOX'' THEN                             ',
'      --Parse the clob so we can work with it ',
'      apex_json.parse (p_values => l_json_values, p_source => l_json_clob); ',
'       ',
'      --Get a count of the products that were passed in ',
'      l_count := apex_json.get_count (p_path => ''.'', p_values => l_json_values); ',
' ',
'      apex_collection.create_or_truncate_collection ( ',
'         p_collection_name   => l_attr_collec_name);  ',
' ',
'      FOR i IN 1 .. l_count ',
'      LOOP ',
'         l_rec_id := ',
'            apex_json.get_varchar2 (p_path     => ''[%d].id'', ',
'                                    p0         => i, ',
'                                    p_values   => l_json_values); ',
'                                    ',
'         APEX_DEBUG.TRACE(p_message => ''Record with id "''||l_rec_id||''" will be added to the collection "''||l_attr_collec_name||''" !'');',
' ',
'         apex_collection.add_member (p_collection_name   => l_attr_collec_name, ',
'                                     p_c001              => l_rec_id); ',
'      END LOOP; ',
'      IF l_count > 1 THEN',
'          APEX_DEBUG.TRACE(p_message => l_count || '' Records were added to the collection "''||l_attr_collec_name||''" !'');',
'      ELSE',
'          APEX_DEBUG.TRACE(p_message => l_count || '' Record was added to the collection "''||l_attr_collec_name||''" !'');',
'      END IF;',
'      ',
'      apex_json.open_object ();',
'      apex_json.write (''message'', p_plugin.attribute_02||''Success!'');',
'      apex_json.close_object;',
' ',
'   ELSE -- must be CLEAR_CHECKBOX ',
'     ',
'      apex_collection.create_or_truncate_collection ( ',
'         p_collection_name   => l_attr_collec_name); ',
'         ',
'      APEX_DEBUG.TRACE(p_message => '' Collection "''||l_attr_collec_name||''" to be returned to UI !'');',
'      ',
'      apex_json.open_object ();',
'      apex_json.write (''message'', ''Success!'');',
'      apex_json.close_object;',
'   END IF; ',
' ',
'   RETURN l_result; ',
'EXCEPTION ',
'   WHEN OTHERS THEN ',
'   ',
'        IF l_request = ''SUBMIT_CHECKBOX'' THEN',
'',
'                l_error_message := p_plugin.attribute_02;--''Error during selection!'';',
'',
'        ELSIF l_request = ''RENDER_CHECKBOX'' THEN',
'',
'                l_error_message := p_plugin.attribute_01;--''Error while trying to render checkboxes!'';',
'',
'        ELSIF l_request = ''CLEAR_CHECKBOX'' THEN',
'',
'                l_error_message := p_plugin.attribute_03;--''Error while trying to reset current selections!'';',
'        END IF;',
'      ',
'      apex_json.open_object ();',
'      apex_json.write (''errorMessage'', l_error_message);',
'      apex_json.close_object;',
'      ',
'      apex_debug.error(''Ajax SQL Errm: %s'', sqlerrm);',
'      apex_debug.error(''Ajax Error Backtrace: %s'', DBMS_UTILITY.format_error_backtrace);',
'      ',
'      RETURN l_result; ',
'END ajax_func; '))
,p_api_version=>2
,p_render_function=>'render_func'
,p_ajax_function=>'ajax_func'
,p_standard_attributes=>'ONLOAD:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.2'
,p_files_version=>103
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224415344364930688)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Render Error Message'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_common=>false
,p_show_in_wizard=>false
,p_default_value=>'Error while trying to render checkboxes!'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>true
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224416174417936810)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Submit Selection(s) Error Message'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_common=>false
,p_show_in_wizard=>false
,p_default_value=>'Error during selection!'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>true
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224416648210943886)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Clear Selection(s) Error Message'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_common=>false
,p_show_in_wizard=>false
,p_default_value=>'Error while trying to reset current selection(s)!'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>true
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224405300552830580)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Collection Name'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'SELECTED_COLLECTION'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(224849460118991945)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Give the name of the collection where the selections will be stored.',
'<br>Note: The name should :<br>',
'<ul>',
'<li> Be unique within an application.</li> ',
'<li> Not have quotation marks.</li>',
'<li>  Be case-insensitive, because collection names are not case-sensitive and will be converted to uppercase.</li>',
'<li> Not exceed 255 characters.</li>',
'<li>  Not contain letters outside the base ASCII character set.</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224405797650830583)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Selector Column'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'IRSELECTOR'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(224849460118991945)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Put here the static id of the column you want to use as a checkbox.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224406053639830583)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Clear Selection(s) on Page Load'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(224849460118991945)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Enable this attribute if you would like to clear selection(s) on page load.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224406402184830584)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Clear on Change of Page Items'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(224849460118991945)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Enable this attribute if you would like to clear selections on change of certain page items.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224406893589830584)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Page Item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(224406402184830584)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Select the page items which will clear the selections on change.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224407235459830584)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Refresh Report'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(224406402184830584)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Enable this attribute if you want to refresh the report when page items are changed.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224414844645920101)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Selection on Row Click'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(224849460118991945)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Enable this attribute if you want to enable selection on row click.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224848928627986506)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Display Column(s)'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enter one or more column static ids to be affected by this action. For multiple columns, separate each column static id with a comma.',
'<br>Leave this empty if you don''t want any column to be rendered as a disabled checkbox.',
'<br><br><b>NOTE: Only the source values (Y/N) will be considered during rendering as checked/unchecked.</b>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(224849460118991945)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>5
,p_prompt=>'Enable Selector'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_supported_ui_types=>'DESKTOP'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'This attribute is used to tell the plugin to render the selection column or not.',
'<br>Enabled  - means that the selector column will be rendered.',
'<br>Disabled - means that we only want to render a display only checkbox.'))
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(224410641414830608)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_name=>'ir_selection_changed'
,p_display_name=>'Selection Changed'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A676C6F62616C2077696E646F772C617065782A2F0A617065782E6B635574696C732E6972436865636B626F78203D207B7D3B0A617065782E6B635574696C732E6972436865636B626F782E6F7074696F6E73203D205B5D3B0A2866756E6374696F6E';
wwv_flow_api.g_varchar2_table(2) := '286F7074696F6E732C206972436B2C207574696C2C20696E666F2C20242C2064612C207365727665722C20726567696F6E2C20756E646566696E656429207B0A20202275736520737472696374223B0A20207661722067436865636B65645265636F7264';
wwv_flow_api.g_varchar2_table(3) := '734172726179203D205B5D2C0A20202020675265706F727446696C74657273203D205B5D2C0A2020202052454E4445525F434845434B424F58203D202752454E4445525F434845434B424F58272C0A202020205355424D49545F434845434B424F58203D';
wwv_flow_api.g_varchar2_table(4) := '20275355424D49545F434845434B424F58272C0A20202020434C4541525F434845434B424F58203D2027434C4541525F434845434B424F58273B0A0A20206972436B2E696E6974203D2066756E6374696F6E2829207B0A202020206972436B2E7265706F';
wwv_flow_api.g_varchar2_table(5) := '72744964203D20272327202B20746869732E74726967676572696E67456C656D656E742E69643B0A202020206F7074696F6E735B6972436B2E7265706F727449645D203D207B7D3B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E';
wwv_flow_api.g_varchar2_table(6) := '636F6E74657874203D20746869733B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E726573756D6543616C6C6261636B203D20746869732E726573756D6543616C6C6261636B3B0A202020206F7074696F6E735B6972436B2E7265';
wwv_flow_api.g_varchar2_table(7) := '706F727449645D2E726566726573685265706F7274203D20746869732E616374696F6E2E61747472696275746530363B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E696E7465726E616C526566726573685265706F7274466C61';
wwv_flow_api.g_varchar2_table(8) := '67203D2066616C73653B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964203D20746869732E616374696F6E2E61747472696275746530323B0A202020206F7074696F6E735B6972436B2E72';
wwv_flow_api.g_varchar2_table(9) := '65706F727449645D2E726F7753656C656374696F6E456E61626C6564203D20746869732E616374696F6E2E61747472696275746530373B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E646973706C61794F6E6C79436F6C756D6E';
wwv_flow_api.g_varchar2_table(10) := '73203D20746869732E616374696F6E2E61747472696275746530383B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E72656E6465724F6E6C7944697361626C65644342203D20746869732E616374696F6E2E617474726962757465';
wwv_flow_api.g_varchar2_table(11) := '3039203D3D20274E27203F2074727565203A2066616C73653B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E616A6178203D207B0A20202020202069643A20746869732E616374696F6E2E616A61784964656E7469666965722C0A';
wwv_flow_api.g_varchar2_table(12) := '20202020202072756E6E696E673A2066616C73652C0A202020202020747970653A2052454E4445525F434845434B424F580A202020207D3B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E706167654974656D73203D2074686973';
wwv_flow_api.g_varchar2_table(13) := '2E616374696F6E2E61747472696275746530353B0A0A20202020696E666F2827496E697420496E746572616374697665205265706F72742043686563626F7820666F72205265706F7274207769746820537461746963204944202227202B206972436B2E';
wwv_flow_api.g_varchar2_table(14) := '7265706F72744964202B2027222127293B0A0A2020202069662028746869732E62726F777365724576656E74203D3D20276C6F61642729207B0A0A20202020202069662028216972436B2E69724861734D756C7469706C655669657773282929207B0A20';
wwv_flow_api.g_varchar2_table(15) := '202020202020206972436B2E68616E646C654C6F61644576656E7428293B0A2020202020207D0A0A202020207D20656C7365207B202F2F53686F756C6420626520636C69636B206576656E740A0A20202020202069662028216972436B2E69724861734D';
wwv_flow_api.g_varchar2_table(16) := '756C7469706C655669657773282920262620216F7074696F6E735B6972436B2E7265706F727449645D2E72656E6465724F6E6C7944697361626C6564434229207B0A20202020202020206972436B2E68616E646C65436C69636B4576656E7428293B0A20';
wwv_flow_api.g_varchar2_table(17) := '20202020207D0A202020207D0A20207D0A0A20206972436B2E676574416C6C436865636B626F786573203D2066756E6374696F6E2829207B0A2020202072657475726E2024286972436B2E7265706F72744964292E66696E64282274645B686561646572';
wwv_flow_api.g_varchar2_table(18) := '732A3D22202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964202B20225D20696E70757422293B0A20207D0A0A20206972436B2E676574436865636B626F78456C656D656E74203D2066756E637469';
wwv_flow_api.g_varchar2_table(19) := '6F6E2870456C656D656E7429207B0A20202020766172206C436865636B426F78456C656D656E742C0A2020202020206C4576656E74546172676574456C656D656E74203D2024286F7074696F6E735B6972436B2E7265706F727449645D2E636F6E746578';
wwv_flow_api.g_varchar2_table(20) := '742E62726F777365724576656E742E746172676574293B0A0A20202020696620286C4576656E74546172676574456C656D656E745B305D2E6E6F64654E616D65203D3D2022494E5055542229207B0A2020202020206C436865636B426F78456C656D656E';
wwv_flow_api.g_varchar2_table(21) := '74203D206C4576656E74546172676574456C656D656E743B0A202020207D20656C7365206966202870456C656D656E742E617474722827686561646572732729203D3D206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F7843';
wwv_flow_api.g_varchar2_table(22) := '6F6C756D6E496429207B0A2020202020206C436865636B426F78456C656D656E74203D2070456C656D656E742E66696E642827696E70757427293B0A202020207D0A2020202072657475726E206C436865636B426F78456C656D656E743B0A20207D0A0A';
wwv_flow_api.g_varchar2_table(23) := '20206972436B2E6765745265706F727446696C74657273203D2066756E6374696F6E2829207B0A2020202072657475726E2024286972436B2E7265706F72744964292E66696E642827756C2E612D4952522D636F6E74726F6C7327292E66696E64282773';
wwv_flow_api.g_varchar2_table(24) := '70616E5B69642A3D22636F6E74726F6C5F74657874225D27293B0A20207D0A0A20206972436B2E636865636B496646696C7465727341726554686553616D65203D2066756E6374696F6E28705072657646696C746572732C20704E657746696C74657273';
wwv_flow_api.g_varchar2_table(25) := '29207B0A202020207661722066696C7465727341726553616D65203D20747275652C0A2020202020207072657646696C74657273417272203D205B5D2C0A2020202020206E657746696C74657273417272203D205B5D3B0A0A2020202070507265764669';
wwv_flow_api.g_varchar2_table(26) := '6C746572732E656163682866756E6374696F6E2829207B0A2020202020207072657646696C746572734172722E7075736828746869732E74657874436F6E74656E74293B0A202020207D293B0A20202020704E657746696C746572732E65616368286675';
wwv_flow_api.g_varchar2_table(27) := '6E6374696F6E2829207B0A2020202020206E657746696C746572734172722E7075736828746869732E74657874436F6E74656E74293B0A202020207D293B0A0A20202020696620284A534F4E2E737472696E67696679287072657646696C746572734172';
wwv_flow_api.g_varchar2_table(28) := '722920213D3D204A534F4E2E737472696E67696679286E657746696C746572734172722929207B0A20202020202066696C7465727341726553616D65203D2066616C73653B0A0A202020207D0A2020202072657475726E2066696C746572734172655361';
wwv_flow_api.g_varchar2_table(29) := '6D653B0A20207D0A0A20206972436B2E757064617465436865636B65645265636F7264734172726179203D2066756E6374696F6E28705265636F726449642C2070436865636B656429207B0A20202020766172207265636F7264203D207B7D3B0A202020';
wwv_flow_api.g_varchar2_table(30) := '207265636F72642E6964203D20705265636F726449643B0A0A202020206966202870436865636B656420262620217574696C2E69734964496E41727261794F626A2867436865636B65645265636F72647341727261795B6972436B2E7265706F72744964';
wwv_flow_api.g_varchar2_table(31) := '5D2C207265636F72642E69642929207B0A0A20202020202067436865636B65645265636F72647341727261795B6972436B2E7265706F727449645D2E70757368287265636F7264293B0A202020202020696E666F28226972436B2E757064617465436865';
wwv_flow_api.g_varchar2_table(32) := '636B65645265636F7264734172726179202D3E205265636F72642041646465643A20222C207265636F7264293B0A0A202020207D20656C736520696620282170436865636B656429207B0A0A20202020202067436865636B65645265636F726473417272';
wwv_flow_api.g_varchar2_table(33) := '61795B6972436B2E7265706F727449645D203D206A51756572792E677265702867436865636B65645265636F72647341727261795B6972436B2E7265706F727449645D2C2066756E6374696F6E28705265636F726429207B0A2020202020202020726574';
wwv_flow_api.g_varchar2_table(34) := '75726E20705265636F72642E696420213D207265636F72642E69643B0A2020202020207D293B0A202020202020696E666F28226972436B2E757064617465436865636B65645265636F7264734172726179202D3E205265636F72642052656D6F7665643A';
wwv_flow_api.g_varchar2_table(35) := '20222C207265636F7264293B0A202020207D0A20207D0A0A20206972436B2E75706461746553746174654F66416C6C43686563626F786573203D2066756E6374696F6E2870436865636B656429207B0A0A202020206972436B2E676574416C6C43686563';
wwv_flow_api.g_varchar2_table(36) := '6B626F78657328292E656163682866756E6374696F6E2829207B0A202020202020746869732E636865636B6564203D2070436865636B65643B0A2020202020206972436B2E757064617465436865636B65645265636F726473417272617928746869732E';
wwv_flow_api.g_varchar2_table(37) := '76616C75652C2070436865636B6564293B0A202020207D293B0A0A20207D0A0A20206972436B2E75706461746553746174654F66436865636B626F78486561646572203D2066756E6374696F6E2870537461746529207B0A202020207661722063686563';
wwv_flow_api.g_varchar2_table(38) := '6B626F78416C6C486561646572203D2024286972436B2E7265706F72744964292E66696E64282274682322202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964292C0A202020202020616C6C436865';
wwv_flow_api.g_varchar2_table(39) := '636B626F786573203D206972436B2E676574416C6C436865636B626F78657328293B0A0A20202020696620287574696C2E6F626A4578697374732870537461746529202626207574696C2E6F626A45786973747328636865636B626F78416C6C48656164';
wwv_flow_api.g_varchar2_table(40) := '65722929207B0A0A202020202020696E666F28226972436B2E75706461746553746174654F66436865636B626F78486561646572202D3E20636865636B626F78416C6C48656164657220657869737473202C20736F2077652077696C6C20736574206368';
wwv_flow_api.g_varchar2_table(41) := '65636B626F78416C6C48656164657220746F20222C20705374617465293B0A202020202020636865636B626F78416C6C4865616465722E66696E642827696E70757427295B305D2E636865636B6564203D207053746174653B0A0A202020207D20656C73';
wwv_flow_api.g_varchar2_table(42) := '65207B0A0A202020202020696620287574696C2E6F626A45786973747328616C6C436865636B626F7865732929207B0A202020202020202076617220616C6C436865636B626F786573436865636B6564203D2028616C6C436865636B626F7865732E6C65';
wwv_flow_api.g_varchar2_table(43) := '6E677468203D3D3D20616C6C436865636B626F7865732E66696C74657228223A636865636B656422292E6C656E677468293B0A2020202020202020696E666F28226972436B2E75706461746553746174654F66436865636B626F78486561646572202D3E';
wwv_flow_api.g_varchar2_table(44) := '20616C6C436865636B626F786573436865636B65643A20222C20616C6C436865636B626F786573436865636B6564293B0A0A2020202020202020696620287574696C2E6F626A45786973747328636865636B626F78416C6C4865616465722929207B0A20';
wwv_flow_api.g_varchar2_table(45) := '202020202020202020696E666F28226972436B2E75706461746553746174654F66436865636B626F78486561646572202D3E20636865636B626F78416C6C48656164657220657869737473202C20736F2077652077696C6C2073657420636865636B626F';
wwv_flow_api.g_varchar2_table(46) := '78416C6C48656164657220746F20222C20616C6C436865636B626F786573436865636B6564293B0A20202020202020202020636865636B626F78416C6C4865616465722E66696E642827696E70757427295B305D2E636865636B6564203D20616C6C4368';
wwv_flow_api.g_varchar2_table(47) := '65636B626F786573436865636B65643B0A20202020202020207D0A2020202020207D0A202020207D0A202020202F2F2074726967676572207468697320746F20666F72636520496E746572616374697665207265706F727420746F20726573697A652069';
wwv_flow_api.g_varchar2_table(48) := '747320636F6C756D6E20686561646572730A20202020242877696E646F77292E7472696767657228226170657877696E646F77726573697A656422293B0A20207D0A0A20206972436B2E75706461746553746174654F66436865636B626F78203D206675';
wwv_flow_api.g_varchar2_table(49) := '6E6374696F6E2870436865636B626F78456C656D656E7429207B0A20202020766172206C436865636B6564203D2070436865636B626F78456C656D656E745B305D2E636865636B65642C0A2020202020206C4576656E74203D206F7074696F6E735B6972';
wwv_flow_api.g_varchar2_table(50) := '436B2E7265706F727449645D2E636F6E746578742E62726F777365724576656E743B0A0A202020206966202824286C4576656E742E746172676574295B305D2E6E6F64654E616D6520213D3D2022494E5055542229207B0A202020202020696E666F2822';
wwv_flow_api.g_varchar2_table(51) := '6972436B2E75706461746553746174654F66436865636B626F78202D3E2054617267657420456C656D656E74206E6F7420696E70757420736F20776520636865636B20696E707574206865726520212024286C4576656E742E746172676574293A20222C';
wwv_flow_api.g_varchar2_table(52) := '2024286C4576656E742E74617267657429293B0A2020202020202F2F206F6E6C7920646F20746869732069662074686520636C69636B20776173206E6F74206F6E2074686520636865636B626F782C0A2020202020202F2F206265636175736520746865';
wwv_flow_api.g_varchar2_table(53) := '20636865636B626F782077696C6C20636865636B20697473656C660A2020202020206C436865636B6564203D2070436865636B626F78456C656D656E745B305D2E636865636B6564203D20216C436865636B65643B0A202020207D0A2020202072657475';
wwv_flow_api.g_varchar2_table(54) := '726E206C436865636B65643B0A20207D0A0A20206972436B2E637265617465436865636B626F78203D2066756E6374696F6E287056616C756529207B0A2020202076617220636865636B626F78203D20646F63756D656E742E637265617465456C656D65';
wwv_flow_api.g_varchar2_table(55) := '6E742827696E70757427293B0A20202020636865636B626F782E74797065203D2022636865636B626F78223B0A20202020636865636B626F782E76616C7565203D207056616C75653B0A2020202072657475726E20636865636B626F783B0A20207D0A0A';
wwv_flow_api.g_varchar2_table(56) := '20206972436B2E72656E64657253656C656374696F6E73203D2066756E6374696F6E2829207B0A2020202076617220616C6C436865636B626F786573203D206972436B2E676574416C6C436865636B626F78657328293B0A20202020696E666F28226972';
wwv_flow_api.g_varchar2_table(57) := '436B2E72656E64657253656C656374696F6E73202D3E2057652077696C6C2072656E6465722073656C656374696F6E20666F7220616C6C20436865636B626F7865733A20222C20616C6C436865636B626F786573293B0A0A20202020696620287574696C';
wwv_flow_api.g_varchar2_table(58) := '2E6F626A4578697374732867436865636B65645265636F72647341727261795B6972436B2E7265706F727449645D2929207B0A202020202020696E666F28276972436B2E72656E64657253656C656374696F6E73202D3E20417272617920776974682063';
wwv_flow_api.g_varchar2_table(59) := '6865636B6564207265636F72647320666F72207265706F72742027202B206972436B2E7265706F72744964202B20272065786973747320736F2077652077696C6C20636865636B20616C6C207265636F72647320746861742061726520696E7369646520';
wwv_flow_api.g_varchar2_table(60) := '2127293B0A202020202020616C6C436865636B626F7865732E656163682866756E6374696F6E2829207B0A202020202020202076617220636865636B626F78456C656D656E74203D20746869732C0A202020202020202020207265636F72644972203D20';
wwv_flow_api.g_varchar2_table(61) := '7B7D3B0A20202020202020207265636F726449722E6964203D20636865636B626F78456C656D656E742E76616C75653B0A2020202020202020636865636B626F78456C656D656E742E636865636B6564203D207574696C2E69734964496E41727261794F';
wwv_flow_api.g_varchar2_table(62) := '626A2867436865636B65645265636F72647341727261795B6972436B2E7265706F727449645D2C207265636F726449722E6964293B0A2020202020207D293B0A202020207D20656C7365207B0A202020202020696E666F28276972436B2E72656E646572';
wwv_flow_api.g_varchar2_table(63) := '53656C656374696F6E73202D3E204172726179207769746820636865636B6564207265636F72647320666F72207265706F72742027202B206972436B2E7265706F72744964202B202720646F6573206E6F7420657869737420736F2077652077696C6C20';
wwv_flow_api.g_varchar2_table(64) := '6E6F742072656E64657220616E792073656C656374696F6E732127293B0A202020207D0A202020206972436B2E75706461746553746174654F66436865636B626F7848656164657228293B0A20207D0A0A20206972436B2E72656E646572436865636B62';
wwv_flow_api.g_varchar2_table(65) := '6F786573203D2066756E6374696F6E2829207B0A2020202069662028216F7074696F6E735B6972436B2E7265706F727449645D2E72656E6465724F6E6C7944697361626C6564434229207B0A20202020202076617220636F6C486561646572203D202428';
wwv_flow_api.g_varchar2_table(66) := '6972436B2E7265706F72744964292E66696E64282274682322202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964292C0A2020202020202020616C6C43656C6C73203D2024286972436B2E7265706F';
wwv_flow_api.g_varchar2_table(67) := '72744964292E66696E64282274645B686561646572732A3D22202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964202B20225D22293B0A0A202020202020696E666F28276972436B2E72656E646572';
wwv_flow_api.g_varchar2_table(68) := '436865636B626F786573202D3E2057652077696C6C2072656E6465722063686563626F78657320666F7220636F6C756D6E202227202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964202B20272221';
wwv_flow_api.g_varchar2_table(69) := '27293B0A0A202020202020696620287574696C2E6F626A45786973747328636F6C4865616465722929207B0A202020202020202076617220636865636B626F78203D206972436B2E637265617465436865636B626F782827616C6C27293B0A0A20202020';
wwv_flow_api.g_varchar2_table(70) := '20202020696E666F28276972436B2E72656E646572436865636B626F786573202D3E2054617267657420636F6C756D6E20686561646572207769746820537461746963204944202227202B206F7074696F6E735B6972436B2E7265706F727449645D2E63';
wwv_flow_api.g_varchar2_table(71) := '6865636B426F78436F6C756D6E4964202B20272220666F756E6420616E642077652077696C6C2072656E64657220636865636B626F782127293B0A0A2020202020202020636F6C4865616465722E66696E6428227370616E22292E656D70747928292E61';
wwv_flow_api.g_varchar2_table(72) := '7070656E6428636865636B626F78293B0A0A2020202020207D20656C7365207B0A2020202020202020617065782E64656275672E6572726F7228276972436B2E72656E646572436865636B626F786573202D3E2054617267657420636F6C756D6E206865';
wwv_flow_api.g_varchar2_table(73) := '61646572207769746820537461746963204944202227202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964202B202722206E6F7420666F756E642127293B0A2020202020207D0A0A20202020202069';
wwv_flow_api.g_varchar2_table(74) := '6620287574696C2E6F626A45786973747328616C6C43656C6C732929207B0A2020202020202020696E666F28276972436B2E72656E646572436865636B626F786573202D3E2054617267657420636F6C756D6E2063656C6C732077697468205374617469';
wwv_flow_api.g_varchar2_table(75) := '63204944202227202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964202B20272220666F756E6420616E642077652077696C6C2072656E64657220636865636B626F7865732127293B0A0A20202020';
wwv_flow_api.g_varchar2_table(76) := '20202020616C6C43656C6C732E656163682866756E6374696F6E2829207B0A202020202020202020207661722076616C75653B0A20202020202020202020696620287574696C2E6F626A45786973747328746869732E6669727374456C656D656E744368';
wwv_flow_api.g_varchar2_table(77) := '696C642929207B0A20202020202020202020202076616C7565203D20746869732E6669727374456C656D656E744368696C642E76616C75653B0A202020202020202020207D20656C7365207B0A20202020202020202020202076616C7565203D20746869';
wwv_flow_api.g_varchar2_table(78) := '732E74657874436F6E74656E743B0A202020202020202020207D0A0A2020202020202020202069662028746869732E636C6173734E616D652E696E6465784F6628276167677265676174652729203C203029207B0A202020202020202020202020242874';
wwv_flow_api.g_varchar2_table(79) := '686973292E656D70747928292E617070656E64286972436B2E637265617465436865636B626F782876616C756529293B0A202020202020202020207D0A20202020202020207D293B0A0A2020202020207D20656C7365207B0A2020202020202020617065';
wwv_flow_api.g_varchar2_table(80) := '782E64656275672E6572726F7228276972436B2E72656E646572436865636B626F786573202D3E2054617267657420636F6C756D6E2063656C6C73207769746820537461746963204944202227202B206F7074696F6E735B6972436B2E7265706F727449';
wwv_flow_api.g_varchar2_table(81) := '645D2E636865636B426F78436F6C756D6E4964202B202722206E6F7420666F756E642127293B0A2020202020207D0A0A202020207D0A20202020696620287574696C2E6F626A457869737473286F7074696F6E735B6972436B2E7265706F727449645D2E';
wwv_flow_api.g_varchar2_table(82) := '646973706C61794F6E6C79436F6C756D6E732929207B0A202020202020766172206C446973706C61794F6E6C79436F6C734172726179203D206F7074696F6E735B6972436B2E7265706F727449645D2E646973706C61794F6E6C79436F6C756D6E732E73';
wwv_flow_api.g_varchar2_table(83) := '706C697428222C22293B0A202020202020696E666F28276972436B2E72656E646572436865636B626F786573202D3E2057652077696C6C2072656E64657220646973706C6179206F6E6C792063686563626F7865732127293B0A202020202020666F7220';
wwv_flow_api.g_varchar2_table(84) := '287661722069203D20303B2069203C206C446973706C61794F6E6C79436F6C7341727261792E6C656E6774683B20692B2B29207B0A202020202020202076617220616C6C43656C6C73203D2024286972436B2E7265706F72744964292E66696E64282274';
wwv_flow_api.g_varchar2_table(85) := '645B686561646572732A3D22202B206C446973706C61794F6E6C79436F6C7341727261795B695D202B20225D22293B0A0A2020202020202020616C6C43656C6C732E656163682866756E6374696F6E2829207B0A0A202020202020202020207661722076';
wwv_flow_api.g_varchar2_table(86) := '616C7565203D20746869732E74657874436F6E74656E743B0A0A2020202020202020202069662028746869732E636C6173734E616D652E696E6465784F6628276167677265676174652729203C203029207B0A2020202020202020202020202428746869';
wwv_flow_api.g_varchar2_table(87) := '73292E656D70747928292E617070656E64286972436B2E637265617465436865636B626F782876616C756529293B0A0A2020202020202020202020206966202876616C7565203D3D2027592729207B0A2020202020202020202020202020242874686973';
wwv_flow_api.g_varchar2_table(88) := '292E66696E642827696E70757427295B305D2E636865636B6564203D20747275653B0A2020202020202020202020207D0A202020202020202020202020242874686973292E66696E642827696E70757427295B305D2E64697361626C6564203D20747275';
wwv_flow_api.g_varchar2_table(89) := '653B0A202020202020202020207D0A20202020202020207D293B0A2020202020207D0A0A202020207D0A202020202F2F2074726967676572207468697320746F20666F72636520496E746572616374697665207265706F727420746F20726573697A6520';
wwv_flow_api.g_varchar2_table(90) := '69747320636F6C756D6E20686561646572730A20202020242877696E646F77292E7472696767657228226170657877696E646F77726573697A656422293B0A20207D0A0A20206972436B2E646F416A6178203D2066756E6374696F6E2870416374696F6E';
wwv_flow_api.g_varchar2_table(91) := '547970652C2070536F7572636529207B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E74797065203D2070416374696F6E547970653B0A0A202020207661722070416A617843616C6C6261636B4E616D65203D206F70';
wwv_flow_api.g_varchar2_table(92) := '74696F6E735B6972436B2E7265706F727449645D2E616A61782E69642C0A2020202020207044617461203D207B0A2020202020202020705F636C6F625F30313A204A534F4E2E737472696E676966792867436865636B65645265636F7264734172726179';
wwv_flow_api.g_varchar2_table(93) := '5B6972436B2E7265706F727449645D292C0A20202020202020207830313A2070416374696F6E547970650A2020202020207D2C0A202020202020704F7074696F6E733B0A0A202020206966202870416374696F6E54797065203D3D20434C4541525F4348';
wwv_flow_api.g_varchar2_table(94) := '45434B424F582026262027696E7465726E616C27203D3D2070536F7572636529207B0A202020202020704F7074696F6E73203D207B0A2020202020202020737563636573733A206972436B2E616A6178537563636573732C0A2020202020202020657272';
wwv_flow_api.g_varchar2_table(95) := '6F723A206972436B2E616A61784572726F720A2020202020207D3B0A2020202020206F7074696F6E735B6972436B2E7265706F727449645D2E696E7465726E616C526566726573685265706F7274466C6167203D20747275653B0A202020207D20656C73';
wwv_flow_api.g_varchar2_table(96) := '65207B0A202020202020704F7074696F6E73203D207B0A20202020202020206C6F6164696E67496E64696361746F723A206972436B2E7265706F727449642C0A20202020202020206C6F6164696E67496E64696361746F72506F736974696F6E3A202763';
wwv_flow_api.g_varchar2_table(97) := '656E7465726564272C0A2020202020202020737563636573733A206972436B2E616A6178537563636573732C0A20202020202020206572726F723A206972436B2E616A61784572726F720A2020202020207D3B0A0A202020207D0A0A2020202069662028';
wwv_flow_api.g_varchar2_table(98) := '216F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E72756E6E696E6729207B0A0A2020202020206F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E72756E6E696E67203D20747275653B0A0A2020202020206170';
wwv_flow_api.g_varchar2_table(99) := '65782E7365727665722E706C7567696E2870416A617843616C6C6261636B4E616D652C2070446174612C20704F7074696F6E73293B0A202020207D0A0A20207D0A0A20206972436B2E616A617853756363657373203D2066756E6374696F6E2870446174';
wwv_flow_api.g_varchar2_table(100) := '612C2070546578745374617475732C20704A7158485229207B0A20202020696E666F28226972436B2E616A61785375636365737320616A61782E747970653A20222C206F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E7479706529';
wwv_flow_api.g_varchar2_table(101) := '3B0A0A20202020696620287574696C2E6F626A45786973747328746869732E726566726573684F626A6563742929207B0A2020202020206972436B2E7265706F72744964203D20746869732E726566726573684F626A6563743B0A202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(102) := '2020696620286F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E74797065203D3D205355424D49545F434845434B424F5829207B0A0A202020202020617065782E6576656E742E74726967676572286972436B2E7265706F72744964';
wwv_flow_api.g_varchar2_table(103) := '2C202769725F73656C656374696F6E5F6368616E67656427293B0A0A202020207D20656C736520696620286F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E74797065203D3D2052454E4445525F434845434B424F5829207B0A0A20';
wwv_flow_api.g_varchar2_table(104) := '202020202067436865636B65645265636F72647341727261795B6972436B2E7265706F727449645D203D2070446174613B0A0A202020202020696620286972436B2E6861735265706F727444617461282929207B0A20202020202020206972436B2E7265';
wwv_flow_api.g_varchar2_table(105) := '6E64657253656C656374696F6E7328293B0A2020202020207D0A0A202020207D20656C736520696620286F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E74797065203D3D20434C4541525F434845434B424F5829207B0A0A202020';
wwv_flow_api.g_varchar2_table(106) := '20202067436865636B65645265636F72647341727261795B6972436B2E7265706F727449645D203D205B5D3B0A0A202020202020696620286F7074696F6E735B6972436B2E7265706F727449645D2E726566726573685265706F7274203D3D2027592720';
wwv_flow_api.g_varchar2_table(107) := '262620216F7074696F6E735B6972436B2E7265706F727449645D2E696E7465726E616C526566726573685265706F7274466C616729207B0A202020202020202024286972436B2E7265706F72744964292E74726967676572282761706578726566726573';
wwv_flow_api.g_varchar2_table(108) := '6827293B0A2020202020207D20656C736520696620286972436B2E6861735265706F727444617461282929207B0A20202020202020206972436B2E75706461746553746174654F66436865636B626F784865616465722866616C7365293B0A2020202020';
wwv_flow_api.g_varchar2_table(109) := '2020206972436B2E75706461746553746174654F66416C6C43686563626F7865732866616C7365293B0A2020202020207D0A202020202020617065782E6576656E742E74726967676572286972436B2E7265706F727449642C202769725F73656C656374';
wwv_flow_api.g_varchar2_table(110) := '696F6E5F6368616E67656427293B0A202020207D0A0A202020202F2A20526573756D6520657865637574696F6E206F6620616374696F6E73206865726520616E6420706173732066616C736520746F207468652063616C6C6261636B2C20746F20696E64';
wwv_flow_api.g_varchar2_table(111) := '6963617465206E6F0A202020206572726F7220686173206F636375727265642E202A2F0A2020202064612E726573756D65286F7074696F6E735B6972436B2E7265706F727449645D2E726573756D6543616C6C6261636B2C2066616C7365293B0A202020';
wwv_flow_api.g_varchar2_table(112) := '206F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E72756E6E696E67203D2066616C73653B0A20207D0A0A20206972436B2E616A61784572726F72203D2066756E6374696F6E2870446174612C2070546578745374617475732C2070';
wwv_flow_api.g_varchar2_table(113) := '4A7158485229207B0A202020206F7074696F6E735B6972436B2E7265706F727449645D2E616A61782E72756E6E696E67203D2066616C73653B0A2020202064612E68616E646C65416A61784572726F727328704A715848522C2070546578745374617475';
wwv_flow_api.g_varchar2_table(114) := '732C2070446174612E6572726F724D6573736167652C206F7074696F6E735B6972436B2E7265706F727449645D2E726573756D6543616C6C6261636B293B0A20207D0A0A20206972436B2E69724861734D756C7469706C655669657773203D2066756E63';
wwv_flow_api.g_varchar2_table(115) := '74696F6E2829207B0A20202020766172207669657773203D2024286972436B2E7265706F72744964292E66696E6428276469762E612D4952522D636F6E74726F6C47726F75702D2D766965777327295B305D2C0A2020202020207374617465203D206661';
wwv_flow_api.g_varchar2_table(116) := '6C73653B0A20202020696620287574696C2E6F626A457869737473282929207B0A2020202020206966202876696577732E6368696C64456C656D656E74436F756E74203E203029207B0A2020202020202020696E666F28226972436B2E69724861734D75';
wwv_flow_api.g_varchar2_table(117) := '6C7469706C655669657773202D3E2057652068617665206D756C7469706C6520766965777320666F72207265706F7274203A2022202B206972436B2E7265706F72744964202B20222C2074686973206D65616E732074686174207069766F742C63686172';
wwv_flow_api.g_varchar2_table(118) := '74206F722067726F7570206279207669657720697320656E61626C656420736F2077652077696C6C206E6F742072656E64657220636865636B626F7865732E22293B0A20202020202020207374617465203D20747275653B0A2020202020207D0A202020';
wwv_flow_api.g_varchar2_table(119) := '207D0A20202020696E666F28226972436B2E69724861734D756C7469706C655669657773202D3E20576520646F6E27742068617665206D756C7469706C6520766965777320666F72207265706F7274203A2022202B206972436B2E7265706F7274496420';
wwv_flow_api.g_varchar2_table(120) := '2B20222C202077652077696C6C2072656E64657220636865636B626F7865732E22293B0A2020202072657475726E2073746174653B0A20207D0A0A20206972436B2E6861735265706F727444617461203D2066756E6374696F6E2829207B0A2020202076';
wwv_flow_api.g_varchar2_table(121) := '61722068617344617461203D20747275652C0A2020202020206E6F44617461466F756E64444956203D2024286972436B2E7265706F72744964292E66696E6428276469762E612D4952522D6E6F446174614D736727293B0A20202020696620287574696C';
wwv_flow_api.g_varchar2_table(122) := '2E6F626A457869737473286E6F44617461466F756E644449562929207B0A20202020202068617344617461203D2066616C73653B0A202020207D0A2020202072657475726E20686173446174613B0A20207D0A0A20206972436B2E68616E646C65526570';
wwv_flow_api.g_varchar2_table(123) := '6F727452656672657368203D2066756E6374696F6E2829207B0A20202020696E666F28226972436B2E68616E646C655265706F727452656672657368206F66205265706F7274203A2022202B206972436B2E7265706F72744964293B0A0A202020206966';
wwv_flow_api.g_varchar2_table(124) := '2028216972436B2E69724861734D756C7469706C6556696577732829202626206972436B2E6861735265706F727444617461282929207B0A2020202020207661722066696C74657273203D206972436B2E6765745265706F727446696C7465727328292C';
wwv_flow_api.g_varchar2_table(125) := '0A202020202020202066696C7465727341726553616D65203D206972436B2E636865636B496646696C7465727341726554686553616D6528675265706F727446696C746572735B6972436B2E7265706F727449645D2C2066696C74657273293B0A0A2020';
wwv_flow_api.g_varchar2_table(126) := '202020206972436B2E72656E646572436865636B626F78657328293B0A0A202020202020696620282166696C7465727341726553616D6529207B0A2020202020202020675265706F727446696C746572735B6972436B2E7265706F727449645D203D2066';
wwv_flow_api.g_varchar2_table(127) := '696C746572733B0A20202020202020206972436B2E636C656172436865636B65645265636F7264734172726179416A61782827696E7465726E616C27293B0A2020202020207D20656C7365207B0A20202020202020206972436B2E72656E64657253656C';
wwv_flow_api.g_varchar2_table(128) := '656374696F6E7328293B0A2020202020207D0A202020207D0A20207D0A0A20206972436B2E7365745265706F72744964546F4974656D73203D2066756E6374696F6E28704974656D7329207B0A20202020766172206C41666665637465644974656D7341';
wwv_flow_api.g_varchar2_table(129) := '727261793B0A20202020696620287574696C2E6F626A45786973747328704974656D732929207B0A0A2020202020206C41666665637465644974656D734172726179203D20704974656D732E73706C697428222C22293B0A202020202020666F72202876';
wwv_flow_api.g_varchar2_table(130) := '61722069203D20303B2069203C206C41666665637465644974656D7341727261792E6C656E6774683B20692B2B29207B0A20202020202020202428272327202B206C41666665637465644974656D7341727261795B695D295B305D2E7365744174747269';
wwv_flow_api.g_varchar2_table(131) := '627574652822646174612D7265706F72742D6964222C206972436B2E7265706F72744964293B0A2020202020207D0A202020207D656C73657B0A202020202020696E666F28224E6F2070616765206974656D7320737065636966696564202122293B0A20';
wwv_flow_api.g_varchar2_table(132) := '2020207D0A20207D0A0A20206972436B2E68616E646C654C6F61644576656E74203D2066756E6374696F6E2829207B0A0A202020206972436B2E72656E646572436865636B626F78657328293B0A0A2020202069662028216F7074696F6E735B6972436B';
wwv_flow_api.g_varchar2_table(133) := '2E7265706F727449645D2E72656E6465724F6E6C7944697361626C6564434229207B0A20202020202067436865636B65645265636F72647341727261795B6972436B2E7265706F727449645D203D205B5D3B0A0A2020202020206972436B2E646F416A61';
wwv_flow_api.g_varchar2_table(134) := '782852454E4445525F434845434B424F58293B0A0A202020202020675265706F727446696C746572735B6972436B2E7265706F727449645D203D206972436B2E6765745265706F727446696C7465727328293B0A0A20202020202024286F7074696F6E73';
wwv_flow_api.g_varchar2_table(135) := '5B6972436B2E7265706F727449645D2E636F6E746578742E74726967676572696E67456C656D656E74292E6F6E282261706578616674657272656672657368222C2066756E6374696F6E2829207B0A20202020202020206972436B2E7265706F72744964';
wwv_flow_api.g_varchar2_table(136) := '203D20272327202B20746869732E69643B0A20202020202020206972436B2E68616E646C655265706F72745265667265736828293B0A2020202020207D293B0A0A2020202020206972436B2E7365745265706F72744964546F4974656D73286F7074696F';
wwv_flow_api.g_varchar2_table(137) := '6E735B6972436B2E7265706F727449645D2E706167654974656D73293B0A0A202020207D0A0A20207D0A0A20206972436B2E68616E646C65436C69636B4576656E74203D2066756E6374696F6E2829207B0A20202020766172206C4576656E74203D206F';
wwv_flow_api.g_varchar2_table(138) := '7074696F6E735B6972436B2E7265706F727449645D2E636F6E746578742E62726F777365724576656E742C0A2020202020206C436865636B626F78436F6C486561646572456C203D2024286C4576656E742E746172676574292E636C6F73657374282274';
wwv_flow_api.g_varchar2_table(139) := '682322202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964292C0A2020202020206C436865636B426F78456C656D656E742C0A2020202020206C436865636B65642C0A2020202020206C5472696765';
wwv_flow_api.g_varchar2_table(140) := '7272696E67526F77456C656D656E74203D2024286C4576656E742E746172676574292E636C6F736573742827747227293B0A0A20202020696620286972436B2E6861735265706F727444617461282929207B0A202020202020696620287574696C2E6F62';
wwv_flow_api.g_varchar2_table(141) := '6A457869737473286C436865636B626F78436F6C486561646572456C2929207B0A2020202020202020696E666F28226972436B2E68616E646C65436C69636B4576656E74202D3E20436865636B626F7820636F6C756D6E20686561646572205472696765';
wwv_flow_api.g_varchar2_table(142) := '7272656420746865206576656E74202122293B0A20202020202020206C436865636B426F78456C656D656E74203D206972436B2E676574436865636B626F78456C656D656E74286C436865636B626F78436F6C486561646572456C293B0A0A2020202020';
wwv_flow_api.g_varchar2_table(143) := '202020696620287574696C2E6F626A457869737473286C436865636B426F78456C656D656E742929207B0A0A202020202020202020206C436865636B6564203D206972436B2E75706461746553746174654F66436865636B626F78286C436865636B426F';
wwv_flow_api.g_varchar2_table(144) := '78456C656D656E74293B0A0A202020202020202020206972436B2E75706461746553746174654F66416C6C43686563626F786573286C436865636B6564293B0A0A202020202020202020206972436B2E646F416A6178285355424D49545F434845434B42';
wwv_flow_api.g_varchar2_table(145) := '4F582C2074727565293B0A20202020202020207D0A2020202020207D20656C736520696620287574696C2E6F626A457869737473286C54726967657272696E67526F77456C656D656E742929207B0A0A2020202020202020696620286F7074696F6E735B';
wwv_flow_api.g_varchar2_table(146) := '6972436B2E7265706F727449645D2E726F7753656C656374696F6E456E61626C6564203D3D2027592729207B0A202020202020202020206C436865636B426F78456C656D656E74203D206C54726967657272696E67526F77456C656D656E742E66696E64';
wwv_flow_api.g_varchar2_table(147) := '282274645B686561646572732A3D22202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C756D6E4964202B20225D20696E70757422293B0A20202020202020202020696E666F28226972436B2E68616E646C6543';
wwv_flow_api.g_varchar2_table(148) := '6C69636B4576656E74202D3E20526F772073656C656374696F6E20697320656E61626C65642C20736F20776520676F7420656C656D656E742066726F6D2074726967676572696E6720726F77202120456C656D656E74203A2022202B206C436865636B42';
wwv_flow_api.g_varchar2_table(149) := '6F78456C656D656E74293B0A20202020202020207D20656C7365207B0A202020202020202020206C436865636B426F78456C656D656E74203D206972436B2E676574436865636B626F78456C656D656E742824286C4576656E742E74617267657429293B';
wwv_flow_api.g_varchar2_table(150) := '0A20202020202020202020696E666F28226972436B2E68616E646C65436C69636B4576656E74202D3E20526F772073656C656374696F6E206973206E6F7420656E61626C65642C20736F207765206F6E6C79206765742074686520636865636B626F7820';
wwv_flow_api.g_varchar2_table(151) := '656C656D656E74206F6E6C792069662074686520636C69636B206973206F6E207468652073656C65637420636865636B626F782077697468206964205B22202B206F7074696F6E735B6972436B2E7265706F727449645D2E636865636B426F78436F6C75';
wwv_flow_api.g_varchar2_table(152) := '6D6E4964202B20225D2063656C6C20697473656C66202120456C656D656E74203A2022202B206C436865636B426F78456C656D656E74293B0A20202020202020207D0A2020202020202020696620287574696C2E6F626A457869737473286C436865636B';
wwv_flow_api.g_varchar2_table(153) := '426F78456C656D656E742929207B0A0A202020202020202020206C436865636B6564203D206972436B2E75706461746553746174654F66436865636B626F78286C436865636B426F78456C656D656E74293B0A0A202020202020202020206972436B2E75';
wwv_flow_api.g_varchar2_table(154) := '7064617465436865636B65645265636F7264734172726179286C436865636B426F78456C656D656E742E76616C28292C206C436865636B6564293B0A0A202020202020202020206972436B2E646F416A6178285355424D49545F434845434B424F582C20';
wwv_flow_api.g_varchar2_table(155) := '74727565293B0A0A202020202020202020206972436B2E75706461746553746174654F66436865636B626F7848656164657228293B0A20202020202020207D0A2020202020207D0A202020207D0A0A20207D0A0A20206972436B2E636C65617243686563';
wwv_flow_api.g_varchar2_table(156) := '6B65645265636F7264734172726179416A6178203D2066756E6374696F6E2870536F757263652C207054726967676572696E674974656D29207B0A202020206966202870536F75726365203D3D20276974656D2729207B0A202020202020696620287574';
wwv_flow_api.g_varchar2_table(157) := '696C2E6F626A4578697374732824287054726967676572696E674974656D292929207B0A20202020202020206972436B2E7265706F72744964203D207054726967676572696E674974656D2E646174617365742E7265706F727449643B0A202020202020';
wwv_flow_api.g_varchar2_table(158) := '20206972436B2E646F416A617828434C4541525F434845434B424F58293B0A2020202020207D0A202020207D20656C7365206966202870536F75726365203D3D2027696E7465726E616C2729207B0A2020202020206972436B2E646F416A617828434C45';
wwv_flow_api.g_varchar2_table(159) := '41525F434845434B424F582C2070536F75726365293B0A202020207D0A20207D0A0A202069662028617065782E64656275672E4C4F475F4C4556454C2E4150505F5452414345203C3D20617065782E64656275672E6765744C6576656C282929207B0A20';
wwv_flow_api.g_varchar2_table(160) := '2020207574696C2E66756E6374696F6E4C6F676765722E6164644C6F6767696E67546F4E616D657370616365286972436B293B0A20207D0A0A7D2928617065782E6B635574696C732E6972436865636B626F782E6F7074696F6E732C20617065782E6B63';
wwv_flow_api.g_varchar2_table(161) := '5574696C732E6972436865636B626F782C20617065782E6B635574696C732C20617065782E64656275672E696E666F2C20617065782E6A51756572792C20617065782E64612C20617065782E7365727665722C20617065782E726567696F6E293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(224411670507869952)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_file_name=>'apex_ir_checkbox.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '617065782E6B635574696C732E6972436865636B626F783D7B7D2C617065782E6B635574696C732E6972436865636B626F782E6F7074696F6E733D5B5D2C66756E6374696F6E28652C722C742C6F2C692C6E2C612C642C63297B22757365207374726963';
wwv_flow_api.g_varchar2_table(2) := '74223B76617220733D5B5D2C6C3D5B5D3B722E696E69743D66756E6374696F6E28297B722E7265706F727449643D2223222B746869732E74726967676572696E67456C656D656E742E69642C655B722E7265706F727449645D3D7B7D2C655B722E726570';
wwv_flow_api.g_varchar2_table(3) := '6F727449645D2E636F6E746578743D746869732C655B722E7265706F727449645D2E726573756D6543616C6C6261636B3D746869732E726573756D6543616C6C6261636B2C655B722E7265706F727449645D2E726566726573685265706F72743D746869';
wwv_flow_api.g_varchar2_table(4) := '732E616374696F6E2E61747472696275746530362C655B722E7265706F727449645D2E696E7465726E616C526566726573685265706F7274466C61673D21312C655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49643D746869732E';
wwv_flow_api.g_varchar2_table(5) := '616374696F6E2E61747472696275746530322C655B722E7265706F727449645D2E726F7753656C656374696F6E456E61626C65643D746869732E616374696F6E2E61747472696275746530372C655B722E7265706F727449645D2E646973706C61794F6E';
wwv_flow_api.g_varchar2_table(6) := '6C79436F6C756D6E733D746869732E616374696F6E2E61747472696275746530382C655B722E7265706F727449645D2E72656E6465724F6E6C7944697361626C656443423D224E223D3D746869732E616374696F6E2E61747472696275746530392C655B';
wwv_flow_api.g_varchar2_table(7) := '722E7265706F727449645D2E616A61783D7B69643A746869732E616374696F6E2E616A61784964656E7469666965722C72756E6E696E673A21312C747970653A2252454E4445525F434845434B424F58227D2C655B722E7265706F727449645D2E706167';
wwv_flow_api.g_varchar2_table(8) := '654974656D733D746869732E616374696F6E2E61747472696275746530352C6F2827496E697420496E746572616374697665205265706F72742043686563626F7820666F72205265706F72742077697468205374617469632049442022272B722E726570';
wwv_flow_api.g_varchar2_table(9) := '6F727449642B27222127292C226C6F6164223D3D746869732E62726F777365724576656E743F722E69724861734D756C7469706C65566965777328297C7C722E68616E646C654C6F61644576656E7428293A722E69724861734D756C7469706C65566965';
wwv_flow_api.g_varchar2_table(10) := '777328297C7C655B722E7265706F727449645D2E72656E6465724F6E6C7944697361626C656443427C7C722E68616E646C65436C69636B4576656E7428297D2C722E676574416C6C436865636B626F7865733D66756E6374696F6E28297B72657475726E';
wwv_flow_api.g_varchar2_table(11) := '206928722E7265706F72744964292E66696E64282274645B686561646572732A3D222B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49642B225D20696E70757422297D2C722E676574436865636B626F78456C656D656E743D66';
wwv_flow_api.g_varchar2_table(12) := '756E6374696F6E2874297B766172206F2C6E3D6928655B722E7265706F727449645D2E636F6E746578742E62726F777365724576656E742E746172676574293B72657475726E22494E505554223D3D6E5B305D2E6E6F64654E616D653F6F3D6E3A742E61';
wwv_flow_api.g_varchar2_table(13) := '74747228226865616465727322293D3D655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49642626286F3D742E66696E642822696E7075742229292C6F7D2C722E6765745265706F727446696C746572733D66756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(14) := '7B72657475726E206928722E7265706F72744964292E66696E642822756C2E612D4952522D636F6E74726F6C7322292E66696E6428277370616E5B69642A3D22636F6E74726F6C5F74657874225D27297D2C722E636865636B496646696C746572734172';
wwv_flow_api.g_varchar2_table(15) := '6554686553616D653D66756E6374696F6E28652C72297B76617220743D21302C6F3D5B5D2C693D5B5D3B72657475726E20652E656163682866756E6374696F6E28297B6F2E7075736828746869732E74657874436F6E74656E74297D292C722E65616368';
wwv_flow_api.g_varchar2_table(16) := '2866756E6374696F6E28297B692E7075736828746869732E74657874436F6E74656E74297D292C4A534F4E2E737472696E67696679286F29213D3D4A534F4E2E737472696E67696679286929262628743D2131292C747D2C722E75706461746543686563';
wwv_flow_api.g_varchar2_table(17) := '6B65645265636F72647341727261793D66756E6374696F6E28652C69297B766172206E3D7B7D3B6E2E69643D652C69262621742E69734964496E41727261794F626A28735B722E7265706F727449645D2C6E2E6964293F28735B722E7265706F72744964';
wwv_flow_api.g_varchar2_table(18) := '5D2E70757368286E292C6F28226972436B2E757064617465436865636B65645265636F7264734172726179202D3E205265636F72642041646465643A20222C6E29293A697C7C28735B722E7265706F727449645D3D6A51756572792E6772657028735B72';
wwv_flow_api.g_varchar2_table(19) := '2E7265706F727449645D2C66756E6374696F6E2865297B72657475726E20652E6964213D6E2E69647D292C6F28226972436B2E757064617465436865636B65645265636F7264734172726179202D3E205265636F72642052656D6F7665643A20222C6E29';
wwv_flow_api.g_varchar2_table(20) := '297D2C722E75706461746553746174654F66416C6C43686563626F7865733D66756E6374696F6E2865297B722E676574416C6C436865636B626F78657328292E656163682866756E6374696F6E28297B746869732E636865636B65643D652C722E757064';
wwv_flow_api.g_varchar2_table(21) := '617465436865636B65645265636F726473417272617928746869732E76616C75652C65297D297D2C722E75706461746553746174654F66436865636B626F784865616465723D66756E6374696F6E286E297B76617220613D6928722E7265706F72744964';
wwv_flow_api.g_varchar2_table(22) := '292E66696E642822746823222B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E4964292C643D722E676574416C6C436865636B626F78657328293B696628742E6F626A457869737473286E292626742E6F626A4578697374732861';
wwv_flow_api.g_varchar2_table(23) := '29296F28226972436B2E75706461746553746174654F66436865636B626F78486561646572202D3E20636865636B626F78416C6C48656164657220657869737473202C20736F2077652077696C6C2073657420636865636B626F78416C6C486561646572';
wwv_flow_api.g_varchar2_table(24) := '20746F20222C6E292C612E66696E642822696E70757422295B305D2E636865636B65643D6E3B656C736520696628742E6F626A457869737473286429297B76617220633D642E6C656E6774683D3D3D642E66696C74657228223A636865636B656422292E';
wwv_flow_api.g_varchar2_table(25) := '6C656E6774683B6F28226972436B2E75706461746553746174654F66436865636B626F78486561646572202D3E20616C6C436865636B626F786573436865636B65643A20222C63292C742E6F626A4578697374732861292626286F28226972436B2E7570';
wwv_flow_api.g_varchar2_table(26) := '6461746553746174654F66436865636B626F78486561646572202D3E20636865636B626F78416C6C48656164657220657869737473202C20736F2077652077696C6C2073657420636865636B626F78416C6C48656164657220746F20222C63292C612E66';
wwv_flow_api.g_varchar2_table(27) := '696E642822696E70757422295B305D2E636865636B65643D63297D692877696E646F77292E7472696767657228226170657877696E646F77726573697A656422297D2C722E75706461746553746174654F66436865636B626F783D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(28) := '74297B766172206E3D745B305D2E636865636B65642C613D655B722E7265706F727449645D2E636F6E746578742E62726F777365724576656E743B72657475726E22494E50555422213D3D6928612E746172676574295B305D2E6E6F64654E616D652626';
wwv_flow_api.g_varchar2_table(29) := '286F28226972436B2E75706461746553746174654F66436865636B626F78202D3E2054617267657420456C656D656E74206E6F7420696E70757420736F20776520636865636B20696E707574206865726520212024286C4576656E742E74617267657429';
wwv_flow_api.g_varchar2_table(30) := '3A20222C6928612E74617267657429292C6E3D745B305D2E636865636B65643D216E292C6E7D2C722E637265617465436865636B626F783D66756E6374696F6E2865297B76617220723D646F63756D656E742E637265617465456C656D656E742822696E';
wwv_flow_api.g_varchar2_table(31) := '70757422293B72657475726E20722E747970653D22636865636B626F78222C722E76616C75653D652C727D2C722E72656E64657253656C656374696F6E733D66756E6374696F6E28297B76617220653D722E676574416C6C436865636B626F7865732829';
wwv_flow_api.g_varchar2_table(32) := '3B6F28226972436B2E72656E64657253656C656374696F6E73202D3E2057652077696C6C2072656E6465722073656C656374696F6E20666F7220616C6C20436865636B626F7865733A20222C65292C742E6F626A45786973747328735B722E7265706F72';
wwv_flow_api.g_varchar2_table(33) := '7449645D293F286F28226972436B2E72656E64657253656C656374696F6E73202D3E204172726179207769746820636865636B6564207265636F72647320666F72207265706F727420222B722E7265706F727449642B222065786973747320736F207765';
wwv_flow_api.g_varchar2_table(34) := '2077696C6C20636865636B20616C6C207265636F72647320746861742061726520696E73696465202122292C652E656163682866756E6374696F6E28297B76617220653D7B7D3B652E69643D746869732E76616C75652C746869732E636865636B65643D';
wwv_flow_api.g_varchar2_table(35) := '742E69734964496E41727261794F626A28735B722E7265706F727449645D2C652E6964297D29293A6F28226972436B2E72656E64657253656C656374696F6E73202D3E204172726179207769746820636865636B6564207265636F72647320666F722072';
wwv_flow_api.g_varchar2_table(36) := '65706F727420222B722E7265706F727449642B2220646F6573206E6F7420657869737420736F2077652077696C6C206E6F742072656E64657220616E792073656C656374696F6E732122292C722E75706461746553746174654F66436865636B626F7848';
wwv_flow_api.g_varchar2_table(37) := '656164657228297D2C722E72656E646572436865636B626F7865733D66756E6374696F6E28297B69662821655B722E7265706F727449645D2E72656E6465724F6E6C7944697361626C65644342297B766172206E3D6928722E7265706F72744964292E66';
wwv_flow_api.g_varchar2_table(38) := '696E642822746823222B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E4964292C613D6928722E7265706F72744964292E66696E64282274645B686561646572732A3D222B655B722E7265706F727449645D2E636865636B426F78';
wwv_flow_api.g_varchar2_table(39) := '436F6C756D6E49642B225D22293B6966286F28276972436B2E72656E646572436865636B626F786573202D3E2057652077696C6C2072656E6465722063686563626F78657320666F7220636F6C756D6E2022272B655B722E7265706F727449645D2E6368';
wwv_flow_api.g_varchar2_table(40) := '65636B426F78436F6C756D6E49642B27222127292C742E6F626A457869737473286E29297B76617220643D722E637265617465436865636B626F782822616C6C22293B6F28276972436B2E72656E646572436865636B626F786573202D3E205461726765';
wwv_flow_api.g_varchar2_table(41) := '7420636F6C756D6E206865616465722077697468205374617469632049442022272B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49642B272220666F756E6420616E642077652077696C6C2072656E64657220636865636B626F';
wwv_flow_api.g_varchar2_table(42) := '782127292C6E2E66696E6428227370616E22292E656D70747928292E617070656E642864297D656C736520617065782E64656275672E6572726F7228276972436B2E72656E646572436865636B626F786573202D3E2054617267657420636F6C756D6E20';
wwv_flow_api.g_varchar2_table(43) := '6865616465722077697468205374617469632049442022272B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49642B2722206E6F7420666F756E642127293B742E6F626A4578697374732861293F286F28276972436B2E72656E64';
wwv_flow_api.g_varchar2_table(44) := '6572436865636B626F786573202D3E2054617267657420636F6C756D6E2063656C6C732077697468205374617469632049442022272B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49642B272220666F756E6420616E64207765';
wwv_flow_api.g_varchar2_table(45) := '2077696C6C2072656E64657220636865636B626F7865732127292C612E656163682866756E6374696F6E28297B76617220653B653D742E6F626A45786973747328746869732E6669727374456C656D656E744368696C64293F746869732E666972737445';
wwv_flow_api.g_varchar2_table(46) := '6C656D656E744368696C642E76616C75653A746869732E74657874436F6E74656E742C746869732E636C6173734E616D652E696E6465784F66282261676772656761746522293C302626692874686973292E656D70747928292E617070656E6428722E63';
wwv_flow_api.g_varchar2_table(47) := '7265617465436865636B626F78286529297D29293A617065782E64656275672E6572726F7228276972436B2E72656E646572436865636B626F786573202D3E2054617267657420636F6C756D6E2063656C6C732077697468205374617469632049442022';
wwv_flow_api.g_varchar2_table(48) := '272B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49642B2722206E6F7420666F756E642127297D696628742E6F626A45786973747328655B722E7265706F727449645D2E646973706C61794F6E6C79436F6C756D6E7329297B76';
wwv_flow_api.g_varchar2_table(49) := '617220633D655B722E7265706F727449645D2E646973706C61794F6E6C79436F6C756D6E732E73706C697428222C22293B6F28226972436B2E72656E646572436865636B626F786573202D3E2057652077696C6C2072656E64657220646973706C617920';
wwv_flow_api.g_varchar2_table(50) := '6F6E6C792063686563626F7865732122293B666F722876617220733D303B733C632E6C656E6774683B732B2B297B28613D6928722E7265706F72744964292E66696E64282274645B686561646572732A3D222B635B735D2B225D2229292E656163682866';
wwv_flow_api.g_varchar2_table(51) := '756E6374696F6E28297B76617220653D746869732E74657874436F6E74656E743B746869732E636C6173734E616D652E696E6465784F66282261676772656761746522293C30262628692874686973292E656D70747928292E617070656E6428722E6372';
wwv_flow_api.g_varchar2_table(52) := '65617465436865636B626F78286529292C2259223D3D65262628692874686973292E66696E642822696E70757422295B305D2E636865636B65643D2130292C692874686973292E66696E642822696E70757422295B305D2E64697361626C65643D213029';
wwv_flow_api.g_varchar2_table(53) := '7D297D7D692877696E646F77292E7472696767657228226170657877696E646F77726573697A656422297D2C722E646F416A61783D66756E6374696F6E28742C6F297B655B722E7265706F727449645D2E616A61782E747970653D743B76617220692C6E';
wwv_flow_api.g_varchar2_table(54) := '3D655B722E7265706F727449645D2E616A61782E69642C613D7B705F636C6F625F30313A4A534F4E2E737472696E6769667928735B722E7265706F727449645D292C7830313A747D3B22434C4541525F434845434B424F58223D3D74262622696E746572';
wwv_flow_api.g_varchar2_table(55) := '6E616C223D3D6F3F28693D7B737563636573733A722E616A6178537563636573732C6572726F723A722E616A61784572726F727D2C655B722E7265706F727449645D2E696E7465726E616C526566726573685265706F7274466C61673D2130293A693D7B';
wwv_flow_api.g_varchar2_table(56) := '6C6F6164696E67496E64696361746F723A722E7265706F727449642C6C6F6164696E67496E64696361746F72506F736974696F6E3A2263656E7465726564222C737563636573733A722E616A6178537563636573732C6572726F723A722E616A61784572';
wwv_flow_api.g_varchar2_table(57) := '726F727D2C655B722E7265706F727449645D2E616A61782E72756E6E696E677C7C28655B722E7265706F727449645D2E616A61782E72756E6E696E673D21302C617065782E7365727665722E706C7567696E286E2C612C6929297D2C722E616A61785375';
wwv_flow_api.g_varchar2_table(58) := '63636573733D66756E6374696F6E28612C642C63297B6F28226972436B2E616A61785375636365737320616A61782E747970653A20222C655B722E7265706F727449645D2E616A61782E74797065292C742E6F626A45786973747328746869732E726566';
wwv_flow_api.g_varchar2_table(59) := '726573684F626A65637429262628722E7265706F727449643D746869732E726566726573684F626A656374292C225355424D49545F434845434B424F58223D3D655B722E7265706F727449645D2E616A61782E747970653F617065782E6576656E742E74';
wwv_flow_api.g_varchar2_table(60) := '72696767657228722E7265706F727449642C2269725F73656C656374696F6E5F6368616E67656422293A2252454E4445525F434845434B424F58223D3D655B722E7265706F727449645D2E616A61782E747970653F28735B722E7265706F727449645D3D';
wwv_flow_api.g_varchar2_table(61) := '612C722E6861735265706F72744461746128292626722E72656E64657253656C656374696F6E732829293A22434C4541525F434845434B424F58223D3D655B722E7265706F727449645D2E616A61782E74797065262628735B722E7265706F727449645D';
wwv_flow_api.g_varchar2_table(62) := '3D5B5D2C225922213D655B722E7265706F727449645D2E726566726573685265706F72747C7C655B722E7265706F727449645D2E696E7465726E616C526566726573685265706F7274466C61673F722E6861735265706F7274446174612829262628722E';
wwv_flow_api.g_varchar2_table(63) := '75706461746553746174654F66436865636B626F78486561646572282131292C722E75706461746553746174654F66416C6C43686563626F78657328213129293A6928722E7265706F72744964292E747269676765722822617065787265667265736822';
wwv_flow_api.g_varchar2_table(64) := '292C617065782E6576656E742E7472696767657228722E7265706F727449642C2269725F73656C656374696F6E5F6368616E6765642229292C6E2E726573756D6528655B722E7265706F727449645D2E726573756D6543616C6C6261636B2C2131292C65';
wwv_flow_api.g_varchar2_table(65) := '5B722E7265706F727449645D2E616A61782E72756E6E696E673D21317D2C722E616A61784572726F723D66756E6374696F6E28742C6F2C69297B655B722E7265706F727449645D2E616A61782E72756E6E696E673D21312C6E2E68616E646C65416A6178';
wwv_flow_api.g_varchar2_table(66) := '4572726F727328692C6F2C742E6572726F724D6573736167652C655B722E7265706F727449645D2E726573756D6543616C6C6261636B297D2C722E69724861734D756C7469706C6556696577733D66756E6374696F6E28297B76617220653D6928722E72';
wwv_flow_api.g_varchar2_table(67) := '65706F72744964292E66696E6428226469762E612D4952522D636F6E74726F6C47726F75702D2D766965777322295B305D2C6E3D21313B72657475726E20742E6F626A45786973747328292626652E6368696C64456C656D656E74436F756E743E302626';
wwv_flow_api.g_varchar2_table(68) := '286F28226972436B2E69724861734D756C7469706C655669657773202D3E2057652068617665206D756C7469706C6520766965777320666F72207265706F7274203A20222B722E7265706F727449642B222C2074686973206D65616E7320746861742070';
wwv_flow_api.g_varchar2_table(69) := '69766F742C6368617274206F722067726F7570206279207669657720697320656E61626C656420736F2077652077696C6C206E6F742072656E64657220636865636B626F7865732E22292C6E3D2130292C6F28226972436B2E69724861734D756C746970';
wwv_flow_api.g_varchar2_table(70) := '6C655669657773202D3E20576520646F6E27742068617665206D756C7469706C6520766965777320666F72207265706F7274203A20222B722E7265706F727449642B222C202077652077696C6C2072656E64657220636865636B626F7865732E22292C6E';
wwv_flow_api.g_varchar2_table(71) := '7D2C722E6861735265706F7274446174613D66756E6374696F6E28297B76617220653D21302C6F3D6928722E7265706F72744964292E66696E6428226469762E612D4952522D6E6F446174614D736722293B72657475726E20742E6F626A457869737473';
wwv_flow_api.g_varchar2_table(72) := '286F29262628653D2131292C657D2C722E68616E646C655265706F7274526566726573683D66756E6374696F6E28297B6966286F28226972436B2E68616E646C655265706F727452656672657368206F66205265706F7274203A20222B722E7265706F72';
wwv_flow_api.g_varchar2_table(73) := '744964292C21722E69724861734D756C7469706C65566965777328292626722E6861735265706F7274446174612829297B76617220653D722E6765745265706F727446696C7465727328292C743D722E636865636B496646696C74657273417265546865';
wwv_flow_api.g_varchar2_table(74) := '53616D65286C5B722E7265706F727449645D2C65293B722E72656E646572436865636B626F78657328292C743F722E72656E64657253656C656374696F6E7328293A286C5B722E7265706F727449645D3D652C722E636C656172436865636B6564526563';
wwv_flow_api.g_varchar2_table(75) := '6F7264734172726179416A61782822696E7465726E616C2229297D7D2C722E7365745265706F72744964546F4974656D733D66756E6374696F6E2865297B766172206E3B696628742E6F626A457869737473286529297B6E3D652E73706C697428222C22';
wwv_flow_api.g_varchar2_table(76) := '293B666F722876617220613D303B613C6E2E6C656E6774683B612B2B2969282223222B6E5B615D295B305D2E7365744174747269627574652822646174612D7265706F72742D6964222C722E7265706F72744964297D656C7365206F28224E6F20706167';
wwv_flow_api.g_varchar2_table(77) := '65206974656D7320737065636966696564202122297D2C722E68616E646C654C6F61644576656E743D66756E6374696F6E28297B722E72656E646572436865636B626F78657328292C655B722E7265706F727449645D2E72656E6465724F6E6C79446973';
wwv_flow_api.g_varchar2_table(78) := '61626C656443427C7C28735B722E7265706F727449645D3D5B5D2C722E646F416A6178282252454E4445525F434845434B424F5822292C6C5B722E7265706F727449645D3D722E6765745265706F727446696C7465727328292C6928655B722E7265706F';
wwv_flow_api.g_varchar2_table(79) := '727449645D2E636F6E746578742E74726967676572696E67456C656D656E74292E6F6E282261706578616674657272656672657368222C66756E6374696F6E28297B722E7265706F727449643D2223222B746869732E69642C722E68616E646C65526570';
wwv_flow_api.g_varchar2_table(80) := '6F72745265667265736828297D292C722E7365745265706F72744964546F4974656D7328655B722E7265706F727449645D2E706167654974656D7329297D2C722E68616E646C65436C69636B4576656E743D66756E6374696F6E28297B766172206E2C61';
wwv_flow_api.g_varchar2_table(81) := '2C643D655B722E7265706F727449645D2E636F6E746578742E62726F777365724576656E742C633D6928642E746172676574292E636C6F736573742822746823222B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E4964292C733D';
wwv_flow_api.g_varchar2_table(82) := '6928642E746172676574292E636C6F736573742822747222293B722E6861735265706F7274446174612829262628742E6F626A4578697374732863293F286F28226972436B2E68616E646C65436C69636B4576656E74202D3E20436865636B626F782063';
wwv_flow_api.g_varchar2_table(83) := '6F6C756D6E206865616465722054726967657272656420746865206576656E74202122292C6E3D722E676574436865636B626F78456C656D656E742863292C742E6F626A457869737473286E29262628613D722E75706461746553746174654F66436865';
wwv_flow_api.g_varchar2_table(84) := '636B626F78286E292C722E75706461746553746174654F66416C6C43686563626F7865732861292C722E646F416A617828225355424D49545F434845434B424F58222C21302929293A742E6F626A4578697374732873292626282259223D3D655B722E72';
wwv_flow_api.g_varchar2_table(85) := '65706F727449645D2E726F7753656C656374696F6E456E61626C65643F286E3D732E66696E64282274645B686561646572732A3D222B655B722E7265706F727449645D2E636865636B426F78436F6C756D6E49642B225D20696E70757422292C6F282269';
wwv_flow_api.g_varchar2_table(86) := '72436B2E68616E646C65436C69636B4576656E74202D3E20526F772073656C656374696F6E20697320656E61626C65642C20736F20776520676F7420656C656D656E742066726F6D2074726967676572696E6720726F77202120456C656D656E74203A20';
wwv_flow_api.g_varchar2_table(87) := '222B6E29293A286E3D722E676574436865636B626F78456C656D656E74286928642E74617267657429292C6F28226972436B2E68616E646C65436C69636B4576656E74202D3E20526F772073656C656374696F6E206973206E6F7420656E61626C65642C';
wwv_flow_api.g_varchar2_table(88) := '20736F207765206F6E6C79206765742074686520636865636B626F7820656C656D656E74206F6E6C792069662074686520636C69636B206973206F6E207468652073656C65637420636865636B626F782077697468206964205B222B655B722E7265706F';
wwv_flow_api.g_varchar2_table(89) := '727449645D2E636865636B426F78436F6C756D6E49642B225D2063656C6C20697473656C66202120456C656D656E74203A20222B6E29292C742E6F626A457869737473286E29262628613D722E75706461746553746174654F66436865636B626F78286E';
wwv_flow_api.g_varchar2_table(90) := '292C722E757064617465436865636B65645265636F7264734172726179286E2E76616C28292C61292C722E646F416A617828225355424D49545F434845434B424F58222C2130292C722E75706461746553746174654F66436865636B626F784865616465';
wwv_flow_api.g_varchar2_table(91) := '7228292929297D2C722E636C656172436865636B65645265636F7264734172726179416A61783D66756E6374696F6E28652C6F297B226974656D223D3D653F742E6F626A4578697374732869286F2929262628722E7265706F727449643D6F2E64617461';
wwv_flow_api.g_varchar2_table(92) := '7365742E7265706F727449642C722E646F416A61782822434C4541525F434845434B424F582229293A22696E7465726E616C223D3D652626722E646F416A61782822434C4541525F434845434B424F58222C65297D2C617065782E64656275672E4C4F47';
wwv_flow_api.g_varchar2_table(93) := '5F4C4556454C2E4150505F54524143453C3D617065782E64656275672E6765744C6576656C28292626742E66756E6374696F6E4C6F676765722E6164644C6F6767696E67546F4E616D6573706163652872297D28617065782E6B635574696C732E697243';
wwv_flow_api.g_varchar2_table(94) := '6865636B626F782E6F7074696F6E732C617065782E6B635574696C732E6972436865636B626F782C617065782E6B635574696C732C617065782E64656275672E696E666F2C617065782E6A51756572792C617065782E64612C617065782E736572766572';
wwv_flow_api.g_varchar2_table(95) := '2C617065782E726567696F6E293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(224412053821871182)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_file_name=>'apex_ir_checkbox.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2F2A676C6F62616C2077696E646F772C617065782A2F0A2F2A2A0A202A2054686973206E616D65737061636520686F6C64730A202A20406E616D6573706163650A202A2F0A617065782E6B635574696C73203D207B7D3B0A2866756E6374696F6E286170';
wwv_flow_api.g_varchar2_table(2) := '65782C20242C207574696C2C20756E646566696E656429207B0A20202275736520737472696374223B0A20207661722073656C66203D207574696C3B0A202073656C662E66756E6374696F6E4C6F67676572203D207B7D3B0A202073656C662E6578636C';
wwv_flow_api.g_varchar2_table(3) := '7564656446756E6374696F6E73203D207B7D3B0A0A202073656C662E66756E6374696F6E4C6F676765722E6C6F67203D20747275653B202F2F536574207468697320746F2066616C736520746F2064697361626C65206C6F6767696E670A0A20202F2A2A';
wwv_flow_api.g_varchar2_table(4) := '0A2020202A20416674657220746869732069732063616C6C65642C20616C6C20646972656374206368696C6472656E206F66207468652070726F7669646564206E616D657370616365206F626A6563742074686174206172650A2020202A2066756E6374';
wwv_flow_api.g_varchar2_table(5) := '696F6E732077696C6C20626520616464656420746F20657863756C64656420617272617920616E6420746865206C6F672077696C6C206E6F7420626520686F6F6B65642E0A2020202A0A2020202A2040706172616D206E616D6573706163654F626A6563';
wwv_flow_api.g_varchar2_table(6) := '7420546865206F626A6563742077686F7365206368696C642066756E6374696F6E7320796F752764206C696B6520746F206E6F7420616464206C6F6767696E6720746F2E0A2020202A0A2020202A204072657475726E20412066756E6374696F6E207468';
wwv_flow_api.g_varchar2_table(7) := '61742077696C6C20706572666F726D206C6F6767696E6720616E64207468656E2063616C6C207468652066756E6374696F6E2E0A2020202A2F0A202073656C662E66756E6374696F6E4C6F676765722E6578636C7564654C6F6767696E67546F4E616D65';
wwv_flow_api.g_varchar2_table(8) := '7370616365203D2066756E6374696F6E286E616D6573706163654F626A65637429207B0A20202020666F722028766172206E616D6520696E206E616D6573706163654F626A65637429207B0A20202020202076617220706F74656E7469616C46756E6374';
wwv_flow_api.g_varchar2_table(9) := '696F6E203D206E616D6573706163654F626A6563745B6E616D655D3B0A0A202020202020696620284F626A6563742E70726F746F747970652E746F537472696E672E63616C6C28706F74656E7469616C46756E6374696F6E29203D3D3D20275B6F626A65';
wwv_flow_api.g_varchar2_table(10) := '63742046756E6374696F6E5D2729207B0A202020202020202073656C662E6578636C7564656446756E6374696F6E735B6E616D655D203D206E616D653B0A2020202020207D0A202020207D0A20207D3B0A0A20202F2A2A0A2020202A2047657473206120';
wwv_flow_api.g_varchar2_table(11) := '66756E6374696F6E2074686174207768656E2063616C6C65642077696C6C206C6F6720696E666F726D6174696F6E2061626F757420697473656C66206966206C6F6767696E67206973207475726E6564206F6E2E0A2020202A202F2F204E4F54453A2054';
wwv_flow_api.g_varchar2_table(12) := '6869732066756E6374696F6E2077696C6C206F6E6C79206C6F67206D6573736167657320696620746865206465627567206C6576656C20697320657175616C20746F204C4F475F4C4556454C2E4150505F5452414345206F72206269676765720A202020';
wwv_flow_api.g_varchar2_table(13) := '2A0A2020202A2040706172616D2066756E63205468652066756E6374696F6E20746F20616464206C6F6767696E6720746F2E0A2020202A2040706172616D206E616D6520546865206E616D65206F66207468652066756E6374696F6E2E0A2020202A0A20';
wwv_flow_api.g_varchar2_table(14) := '20202A204072657475726E20412066756E6374696F6E20746861742077696C6C20706572666F726D206C6F6767696E6720616E64207468656E2063616C6C207468652066756E6374696F6E2E0A2020202A2F0A202073656C662E66756E6374696F6E4C6F';
wwv_flow_api.g_varchar2_table(15) := '676765722E6765744C6F676761626C6546756E6374696F6E203D2066756E6374696F6E2866756E632C206E616D6529207B0A2020202072657475726E2066756E6374696F6E2829207B0A202020202020766172206C6F6754657874203D202728273B0A20';
wwv_flow_api.g_varchar2_table(16) := '2020202020636F6E736F6C652E67726F7570436F6C6C6170736564286E616D65293B0A2020202020207661722072657475726E56616C7565203D2066756E632E6170706C7928746869732C20617267756D656E7473293B0A0A202020202020666F722028';
wwv_flow_api.g_varchar2_table(17) := '7661722069203D20303B2069203C20617267756D656E74732E6C656E6774683B20692B2B29207B0A20202020202020206966202869203E203029207B0A202020202020202020206C6F6754657874202B3D20272C20273B0A20202020202020207D0A0A20';
wwv_flow_api.g_varchar2_table(18) := '2020202020202069662028747970656F6620617267756D656E74735B695D20213D3D2027737472696E6727207C7C20747970656F6620617267756D656E74735B695D20213D3D20276E756D6265722729207B0A202020202020202020206C6F6754657874';
wwv_flow_api.g_varchar2_table(19) := '202B3D2073656C662E637573746F6D537472696E6769667928617267756D656E74735B695D293B0A20202020202020207D20656C7365207B0A202020202020202020206C6F6754657874202B3D20617267756D656E74735B695D3B0A2020202020202020';
wwv_flow_api.g_varchar2_table(20) := '7D0A2020202020207D0A2020202020206C6F6754657874202B3D2027293B273B0A0A20202020202076617220636F6E736F6C655461626C65203D205B7B0A20202020202020202746756E6374696F6E206E616D65273A206E616D652C0A20202020202020';
wwv_flow_api.g_varchar2_table(21) := '202746756E6374696F6E20617267756D656E7473273A206C6F67546578742C0A20202020202020202752657475726E65642056616C7565273A2028747970656F662072657475726E56616C7565203D3D2027626F6F6C65616E27207C7C2073656C662E6F';
wwv_flow_api.g_varchar2_table(22) := '626A4578697374732872657475726E56616C75652929203F2072657475726E56616C7565203A20274E6F2076616C75652072657475726E6564206F7220756E646566696E656421270A2020202020207D5D3B0A0A202020202020636F6E736F6C652E7461';
wwv_flow_api.g_varchar2_table(23) := '626C6528636F6E736F6C655461626C65293B0A202020202020636F6E736F6C652E67726F7570456E6428293B0A20202020202072657475726E2072657475726E56616C75653B0A202020207D0A20207D0A0A20202F2A2A0A2020202A2054686973206675';
wwv_flow_api.g_varchar2_table(24) := '6E6374696F6E2077696C6C206F6E6C79206C6F67206D6573736167657320696620746865206465627567206C6576656C20697320657175616C20746F204C4F475F4C4556454C2E454E47494E455F54524143452E0A2020202A0A2020202A204070617261';
wwv_flow_api.g_varchar2_table(25) := '6D2066756E63205468652066756E6374696F6E20746F20616464206C6F6767696E6720746F2E0A2020202A2040706172616D206E616D6520546865206E616D65206F66207468652066756E6374696F6E2E0A2020202A0A2020202A204072657475726E20';
wwv_flow_api.g_varchar2_table(26) := '412066756E6374696F6E20746861742077696C6C20706572666F726D206C6F6767696E6720616E64207468656E2063616C6C207468652066756E6374696F6E2E0A2020202A2F0A202073656C662E66756E6374696F6E4C6F676765722E4C6F6754726163';
wwv_flow_api.g_varchar2_table(27) := '65203D2066756E6374696F6E28704D6573736167652C2070547261636529207B0A20202020617065782E64656275672E6D65737361676528617065782E64656275672E4C4F475F4C4556454C2E454E47494E455F54524143452C20704D65737361676529';
wwv_flow_api.g_varchar2_table(28) := '3B0A20207D0A0A20202F2A2A0A2020202A20416674657220746869732069732063616C6C65642C20616C6C20646972656374206368696C6472656E206F66207468652070726F7669646564206E616D657370616365206F626A6563742074686174206172';
wwv_flow_api.g_varchar2_table(29) := '650A2020202A2066756E6374696F6E732077696C6C206C6F67207468656972206E616D652061732077656C6C206173207468652076616C756573206F662074686520706172616D65746572732070617373656420696E2E0A2020202A0A2020202A204070';
wwv_flow_api.g_varchar2_table(30) := '6172616D206E616D6573706163654F626A65637420546865206F626A6563742077686F7365206368696C642066756E6374696F6E7320796F752764206C696B6520746F20616464206C6F6767696E6720746F2E0A2020202A2F0A202073656C662E66756E';
wwv_flow_api.g_varchar2_table(31) := '6374696F6E4C6F676765722E6164644C6F6767696E67546F4E616D657370616365203D2066756E6374696F6E286E616D6573706163654F626A65637429207B0A20202020666F722028766172206E616D6520696E206E616D6573706163654F626A656374';
wwv_flow_api.g_varchar2_table(32) := '29207B0A20202020202076617220706F74656E7469616C46756E6374696F6E203D206E616D6573706163654F626A6563745B6E616D655D3B0A202020202020696620284F626A6563742E70726F746F747970652E746F537472696E672E63616C6C28706F';
wwv_flow_api.g_varchar2_table(33) := '74656E7469616C46756E6374696F6E29203D3D3D20275B6F626A6563742046756E6374696F6E5D272026260A20202020202020202173656C662E6578636C7564656446756E6374696F6E735B6E616D655D29207B0A20202020202020206E616D65737061';
wwv_flow_api.g_varchar2_table(34) := '63654F626A6563745B6E616D655D203D2073656C662E66756E6374696F6E4C6F676765722E6765744C6F676761626C6546756E6374696F6E28706F74656E7469616C46756E6374696F6E2C206E616D65293B0A202020202020202073656C662E6578636C';
wwv_flow_api.g_varchar2_table(35) := '7564656446756E6374696F6E735B6E616D655D203D206E616D653B0A2020202020207D0A202020207D0A20207D0A20202F2A2A0A2020202A20546869732066756E6374696F6E206973207573656420746F20636865636B20696620616E20696420697320';
wwv_flow_api.g_varchar2_table(36) := '636F6E7461696E656420696E206172726179206F66206F626A656374732E0A2020202A0A2020202A2040706172616D2070417272617920546865206172726179206F66206F626A656374732C2074686520226D656D626572732220617265206578706563';
wwv_flow_api.g_varchar2_table(37) := '74656420746F20686176652070726F7065727479206E616D65642069642E0A2020202A2040706172616D207049642020202054686520696420666F722077686963682077652077696C6C206C6F6F6B20696E20746865206172726179206F66206F626A65';
wwv_flow_api.g_varchar2_table(38) := '63747320746F207365206966206974206578697374732E0A2020202A2F0A202073656C662E69734964496E41727261794F626A203D2066756E6374696F6E287041727261792C2070496429207B0A20202020766172206578697374733B0A20202020666F';
wwv_flow_api.g_varchar2_table(39) := '7220287661722069203D20303B2069203C207041727261792E6C656E6774683B20692B2B29207B0A202020202020696620287041727261795B695D2E6964203D3D2070496429207B0A2020202020202020657869737473203D20747275653B0A20202020';
wwv_flow_api.g_varchar2_table(40) := '20202020627265616B3B0A2020202020207D20656C7365207B0A2020202020202020657869737473203D2066616C73653B0A2020202020207D0A202020207D0A2020202072657475726E206578697374733B0A20207D0A20202F2A2A0A2020202A205468';
wwv_flow_api.g_varchar2_table(41) := '69732066756E6374696F6E206973207573656420746F20636865636B2069662061206A617661736372697074206F626A65637420636F6E7461696E7320656C656D656E7473206F7220697320756E646566696E65642E0A2020202A0A2020202A20407061';
wwv_flow_api.g_varchar2_table(42) := '72616D20704F626A20546865206F626A6563742C20776865726520746865206F626A6563742063616E20656974686572206265206120737472696E67206F626A656374206F7220616E206172726179206F626A656374206574632E0A2020202A2F0A2020';
wwv_flow_api.g_varchar2_table(43) := '73656C662E6F626A457869737473203D2066756E6374696F6E28704F626A29207B0A20202020696628704F626A203D3D206E756C6C297B0A20202020202072657475726E2066616C73653B0A202020207D656C73652069662028747970656F6620704F62';
wwv_flow_api.g_varchar2_table(44) := '6A203D3D3D2027756E646566696E65642729207B0A20202020202072657475726E2066616C73653B0A202020207D0A2020202072657475726E20704F626A2E6C656E677468203E20303B0A20207D0A20200A202073656C662E637573746F6D537472696E';
wwv_flow_api.g_varchar2_table(45) := '67696679203D2066756E6374696F6E287629207B0A20202020636F6E7374206361636865203D206E65772053657428293B0A2020202072657475726E204A534F4E2E737472696E6769667928762C2066756E6374696F6E286B65792C2076616C75652920';
wwv_flow_api.g_varchar2_table(46) := '7B0A20202020202069662028747970656F662076616C7565203D3D3D20276F626A656374272026262076616C756520213D3D206E756C6C29207B0A20202020202020206966202863616368652E6861732876616C75652929207B0A202020202020202020';
wwv_flow_api.g_varchar2_table(47) := '202F2F2043697263756C6172207265666572656E636520666F756E640A20202020202020202020747279207B0A2020202020202020202020202F2F20496620746869732076616C756520646F6573206E6F74207265666572656E6365206120706172656E';
wwv_flow_api.g_varchar2_table(48) := '742069742063616E20626520646564757065640A20202020202020202020202072657475726E204A534F4E2E7061727365284A534F4E2E737472696E676966792876616C756529293B0A202020202020202020207D206361746368202865727229207B0A';
wwv_flow_api.g_varchar2_table(49) := '2020202020202020202020202F2F2064697363617264206B65792069662076616C75652063616E6E6F7420626520646564757065640A20202020202020202020202072657475726E3B0A202020202020202020207D0A20202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(50) := '202020202F2F2053746F72652076616C756520696E206F7572207365740A202020202020202063616368652E6164642876616C7565293B0A2020202020207D0A20202020202072657475726E2076616C75653B0A202020207D293B0A20207D3B0A0A0A7D';
wwv_flow_api.g_varchar2_table(51) := '2928617065782C20617065782E6A51756572792C20617065782E6B635574696C73293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(224412422867872097)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_file_name=>'apex_kc_utils.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '617065782E6B635574696C733D7B7D2C66756E6374696F6E286E2C652C742C6F297B2275736520737472696374223B76617220723D743B722E66756E6374696F6E4C6F676765723D7B7D2C722E6578636C7564656446756E6374696F6E733D7B7D2C722E';
wwv_flow_api.g_varchar2_table(2) := '66756E6374696F6E4C6F676765722E6C6F673D21302C722E66756E6374696F6E4C6F676765722E6578636C7564654C6F6767696E67546F4E616D6573706163653D66756E6374696F6E286E297B666F7228766172206520696E206E297B76617220743D6E';
wwv_flow_api.g_varchar2_table(3) := '5B655D3B225B6F626A6563742046756E6374696F6E5D223D3D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C287429262628722E6578636C7564656446756E6374696F6E735B655D3D65297D7D2C722E66756E6374696F6E';
wwv_flow_api.g_varchar2_table(4) := '4C6F676765722E6765744C6F676761626C6546756E6374696F6E3D66756E6374696F6E286E2C65297B72657475726E2066756E6374696F6E28297B76617220743D2228223B636F6E736F6C652E67726F7570436F6C6C61707365642865293B666F722876';
wwv_flow_api.g_varchar2_table(5) := '6172206F3D6E2E6170706C7928746869732C617267756D656E7473292C753D303B753C617267756D656E74732E6C656E6774683B752B2B29753E30262628742B3D222C2022292C22737472696E6722213D747970656F6620617267756D656E74735B755D';
wwv_flow_api.g_varchar2_table(6) := '7C7C226E756D62657222213D747970656F6620617267756D656E74735B755D3F742B3D722E637573746F6D537472696E6769667928617267756D656E74735B755D293A742B3D617267756D656E74735B755D3B76617220693D5B7B2246756E6374696F6E';
wwv_flow_api.g_varchar2_table(7) := '206E616D65223A652C2246756E6374696F6E20617267756D656E7473223A742B3D22293B222C2252657475726E65642056616C7565223A22626F6F6C65616E223D3D747970656F66206F7C7C722E6F626A457869737473286F293F6F3A224E6F2076616C';
wwv_flow_api.g_varchar2_table(8) := '75652072657475726E6564206F7220756E646566696E656421227D5D3B72657475726E20636F6E736F6C652E7461626C652869292C636F6E736F6C652E67726F7570456E6428292C6F7D7D2C722E66756E6374696F6E4C6F676765722E4C6F6754726163';
wwv_flow_api.g_varchar2_table(9) := '653D66756E6374696F6E28652C74297B6E2E64656275672E6D657373616765286E2E64656275672E4C4F475F4C4556454C2E454E47494E455F54524143452C65297D2C722E66756E6374696F6E4C6F676765722E6164644C6F6767696E67546F4E616D65';
wwv_flow_api.g_varchar2_table(10) := '73706163653D66756E6374696F6E286E297B666F7228766172206520696E206E297B76617220743D6E5B655D3B225B6F626A6563742046756E6374696F6E5D22213D3D4F626A6563742E70726F746F747970652E746F537472696E672E63616C6C287429';
wwv_flow_api.g_varchar2_table(11) := '7C7C722E6578636C7564656446756E6374696F6E735B655D7C7C286E5B655D3D722E66756E6374696F6E4C6F676765722E6765744C6F676761626C6546756E6374696F6E28742C65292C722E6578636C7564656446756E6374696F6E735B655D3D65297D';
wwv_flow_api.g_varchar2_table(12) := '7D2C722E69734964496E41727261794F626A3D66756E6374696F6E286E2C65297B666F722876617220742C6F3D303B6F3C6E2E6C656E6774683B6F2B2B297B6966286E5B6F5D2E69643D3D65297B743D21303B627265616B7D743D21317D72657475726E';
wwv_flow_api.g_varchar2_table(13) := '20747D2C722E6F626A4578697374733D66756E6374696F6E286E297B72657475726E206E756C6C213D6E262628766F69642030213D3D6E26266E2E6C656E6774683E30297D2C722E637573746F6D537472696E676966793D66756E6374696F6E286E297B';
wwv_flow_api.g_varchar2_table(14) := '636F6E737420653D6E6577205365743B72657475726E204A534F4E2E737472696E67696679286E2C66756E6374696F6E286E2C74297B696628226F626A656374223D3D747970656F66207426266E756C6C213D3D74297B696628652E6861732874292974';
wwv_flow_api.g_varchar2_table(15) := '72797B72657475726E204A534F4E2E7061727365284A534F4E2E737472696E67696679287429297D6361746368286E297B72657475726E7D652E6164642874297D72657475726E20747D297D7D28617065782C617065782E6A51756572792C617065782E';
wwv_flow_api.g_varchar2_table(16) := '6B635574696C73293B0A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(224412800942873165)
,p_plugin_id=>wwv_flow_api.id(224405160840830550)
,p_file_name=>'apex_kc_utils.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
