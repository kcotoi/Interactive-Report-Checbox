create or replace PACKAGE BODY "IR_CHECKBOX_UTIL"
AS

FUNCTION printattributes
(
   p_dynamic_action_render_result   IN apex_plugin.t_dynamic_action_render_result
)
   RETURN CLOB
IS
BEGIN
   apex_json.initialize_clob_output;

   apex_json.open_object;
   apex_json.write ('type', 'apex_plugin.t_dynamic_action_render_result');

   apex_json.write ('javascript_function',
                    p_dynamic_action_render_result.javascript_function);
   apex_json.write ('ajax_identifier', p_dynamic_action_render_result.ajax_identifier);
   apex_json.write ('attribute_01', p_dynamic_action_render_result.attribute_01);
   apex_json.write ('attribute_02', p_dynamic_action_render_result.attribute_02);

   apex_json.close_object;

   RETURN apex_json.get_clob_output;
END printattributes;


------------------------

FUNCTION printattributes (p_plugin IN apex_plugin.t_plugin)
   RETURN CLOB
IS
BEGIN
   apex_json.initialize_clob_output;

   apex_json.open_object;
   apex_json.write ('type', 'apex_plugin.t_plugin');

   apex_json.write ('name', p_plugin.name);
   apex_json.write ('file_prefix', p_plugin.file_prefix);
   apex_json.write ('attribute_01', p_plugin.attribute_01);
   apex_json.write ('attribute_02', p_plugin.attribute_02);

   apex_json.close_object;

   RETURN apex_json.get_clob_output;
END printattributes;

------------------------

FUNCTION printattributes (p_dynamic_action IN apex_plugin.t_dynamic_action)
   RETURN CLOB
IS
BEGIN
   apex_json.initialize_clob_output;

   apex_json.open_object;
   apex_json.write ('type', 'apex_plugin.t_dynamic_action');

   apex_json.write ('id',
                    p_dynamic_action.id,
                    FALSE);
   apex_json.write ('action',
                    p_dynamic_action.action,
                    FALSE);
   apex_json.write ('attribute_01',
                    p_dynamic_action.attribute_01,
                    TRUE);
   apex_json.write ('attribute_02',
                    p_dynamic_action.attribute_02,
                    TRUE);

   apex_json.close_object;

   RETURN apex_json.get_clob_output;
END printattributes;

FUNCTION render_func
(
   p_dynamic_action   IN apex_plugin.t_dynamic_action,
   p_plugin           IN apex_plugin.t_plugin
)
   RETURN apex_plugin.t_dynamic_action_render_result
IS
   l_result             apex_plugin.t_dynamic_action_render_result;

   l_attr_collec_name           VARCHAR2 (255) := p_dynamic_action.attribute_01;
   l_attr_col_id                VARCHAR2 (100)   := p_dynamic_action.attribute_02;
   l_trunc_coll_on_change_items VARCHAR2 (1)     := p_dynamic_action.attribute_04;
   l_items                      VARCHAR2 (32767) := p_dynamic_action.attribute_05;
   l_items_vc_arr2              APEX_APPLICATION_GLOBAL.VC_ARR2;
BEGIN
   l_result.ajax_identifier := wwv_flow_plugin.get_ajax_identifier;

   APEX_DEBUG.TRACE(p_message => 'Render checboxes DA id = ' || wwv_flow_plugin.get_ajax_identifier);

   IF l_trunc_coll_on_change_items = 'Y' THEN

       APEX_DEBUG.TRACE(p_message => 'Truncate collection on change of items is enabbled  l_trunc_coll_on_change_items = ' || l_trunc_coll_on_change_items);

       l_items_vc_arr2 := APEX_UTIL.STRING_TO_TABLE(l_items,',');

       FOR z IN 1..l_items_vc_arr2.count LOOP
         APEX_DEBUG.TRACE(p_message => 'We are settiong onchange attribbute for item = ' || l_items_vc_arr2(z) ||' to clear collection!');
         apex_javascript.add_inline_code (
                                            p_code => '$("#'||l_items_vc_arr2(z)||'")[0].setAttribute("onchange", "apex.kcUtils.irCheckbox.clearCheckedRecordsArrayAjax(''item'',this)")',
                                            p_key  => 'refresh_collection_widget_function'||l_attr_collec_name||z );
         IF z = 1 THEN
             l_result.attribute_08 := l_items_vc_arr2(z);
         ELSE
             l_result.attribute_08 := l_result.attribute_08 || ',' || l_items_vc_arr2(z);
         END IF;
       END LOOP;
  END IF;
   APEX_DEBUG.TRACE(p_message => 'Hooking the pex.kcUtils.irCheckbox.init function to Dynamic Action !');
   l_result.javascript_function := 'apex.kcUtils.irCheckbox.init';

   -- used to be printed in debug console when DEBUG is on
   l_result.attribute_01    := l_attr_collec_name;
   l_result.attribute_02    := l_attr_col_id;
   l_result.attribute_05    := p_dynamic_action.attribute_05;
   l_result.attribute_06    := p_dynamic_action.attribute_06;
   l_result.attribute_07    := p_dynamic_action.attribute_07;
   l_result.attribute_08    := p_dynamic_action.attribute_08;
   l_result.attribute_09    := p_dynamic_action.attribute_09;

   IF apex_application.g_debug THEN
      apex_plugin_util.debug_dynamic_action (p_plugin           => p_plugin,
                                             p_dynamic_action   => p_dynamic_action);

      apex_javascript.add_onload_code (
            '
        apex.debug.info("p_dynamic_action", '
         || printattributes (p_dynamic_action)
         || ');
        apex.debug.info("p_plugin",         '
         || printattributes (p_plugin)
         || ');
        apex.debug.info("l_result",         '
         || printattributes (l_result)
         || ');
      ');
   END IF;
   APEX_DEBUG.TRACE(p_message => 'END of Rndering function!');
   RETURN l_result;
END render_func;


FUNCTION ajax_func
(
   p_dynamic_action   IN apex_plugin.t_dynamic_action,
   p_plugin           IN apex_plugin.t_plugin
)
   RETURN apex_plugin.t_dynamic_action_ajax_result
IS
   l_result             apex_plugin.t_dynamic_action_ajax_result;
   l_json_clob          CLOB := apex_application.g_clob_01;
   l_json_values        apex_json.t_values;
   l_count              PLS_INTEGER;
   l_rec_id             VARCHAR2 (4000);
   l_attr_collec_name   VARCHAR2 (255) := p_dynamic_action.attribute_01;
   l_attr_truncate      VARCHAR2 (32767) := p_dynamic_action.attribute_03;
   l_request            VARCHAR2 (100) := apex_application.g_x01;
   l_checkedrecords     CLOB := empty_clob ();
   l_chunk_size         NUMBER := 4000;
   l_error_message      VARCHAR2 (32767);
BEGIN
   APEX_DEBUG.TRACE(p_message => 'Ajax function called for DA with id '||wwv_flow_plugin.get_ajax_identifier||' with request = '||l_request||' !');
   IF l_request = 'RENDER_CHECKBOX' THEN


      apex_json.initialize_clob_output;
      apex_json.open_array ();

      IF apex_collection.collection_exists (p_collection_name => l_attr_collec_name) THEN
        APEX_DEBUG.TRACE(p_message => 'Collection "'||l_attr_collec_name||'" existis!');
        IF l_attr_truncate = 'Y' THEN
           APEX_DEBUG.TRACE(p_message => 'Truncate collection on page load attribute is enabled so we will truncate collection "'||l_attr_collec_name||'" !');
           apex_collection.create_or_truncate_collection (
             p_collection_name   => l_attr_collec_name);

        ELSE
         APEX_DEBUG.TRACE(p_message => 'Truncate collection on page load attribute is not enabled so we will return collection "'||l_attr_collec_name||'" members to UI !');
         FOR record IN (SELECT c001 AS id
                          FROM apex_collections
                         WHERE collection_name = l_attr_collec_name)
         LOOP
            APEX_DEBUG.TRACE(p_message => 'Record with id  "'||record.id||'" is returned to UI !');
            apex_json.open_object ();
            apex_json.write ('id', record.id);
            apex_json.close_object;
         END LOOP;

        END IF;

      END IF;

      apex_json.close_array;

      l_checkedrecords := apex_json.get_clob_output;

      apex_json.free_output;

      IF length (l_checkedrecords) > 0 THEN

         FOR i IN 0 .. floor (length (l_checkedrecords) / l_chunk_size)
         LOOP
            sys.htp.prn (substr (l_checkedrecords,
                                 i * l_chunk_size + 1,
                                 l_chunk_size));
         END LOOP;
      ELSE
          APEX_DEBUG.TRACE(p_message => 'There are no selected records in the collection "'||l_attr_collec_name||'" to be returned to UI !');
      END IF;

   ELSIF  l_request = 'SUBMIT_CHECKBOX' THEN
      --Parse the clob so we can work with it
      apex_json.parse (p_values => l_json_values, p_source => l_json_clob);

      --Get a count of the products that were passed in
      l_count := apex_json.get_count (p_path => '.', p_values => l_json_values);

      apex_collection.create_or_truncate_collection (
         p_collection_name   => l_attr_collec_name);

      FOR i IN 1 .. l_count
      LOOP
         l_rec_id :=
            apex_json.get_varchar2 (p_path     => '[%d].id',
                                    p0         => i,
                                    p_values   => l_json_values);

         APEX_DEBUG.TRACE(p_message => 'Record with id "'||l_rec_id||'" will be added to the collection "'||l_attr_collec_name||'" !');

         apex_collection.add_member (p_collection_name   => l_attr_collec_name,
                                     p_c001              => l_rec_id);
      END LOOP;
      IF l_count > 1 THEN
          APEX_DEBUG.TRACE(p_message => l_count || ' Records were added to the collection "'||l_attr_collec_name||'" !');
      ELSE
          APEX_DEBUG.TRACE(p_message => l_count || ' Record was added to the collection "'||l_attr_collec_name||'" !');
      END IF;

      apex_json.open_object ();
      apex_json.write ('message', p_plugin.attribute_02||'Success!');
      apex_json.close_object;

   ELSE -- must be CLEAR_CHECKBOX

      apex_collection.create_or_truncate_collection (
         p_collection_name   => l_attr_collec_name);

      APEX_DEBUG.TRACE(p_message => ' Collection "'||l_attr_collec_name||'" to be returned to UI !');

      apex_json.open_object ();
      apex_json.write ('message', 'Success!');
      apex_json.close_object;
   END IF;

   RETURN l_result;
EXCEPTION
   WHEN OTHERS THEN

        IF l_request = 'SUBMIT_CHECKBOX' THEN

                l_error_message := p_plugin.attribute_02;--'Error during selection!';

        ELSIF l_request = 'RENDER_CHECKBOX' THEN

                l_error_message := p_plugin.attribute_01;--'Error while trying to render checkboxes!';

        ELSIF l_request = 'CLEAR_CHECKBOX' THEN

                l_error_message := p_plugin.attribute_03;--'Error while trying to reset current selections!';
        END IF;

      apex_json.open_object ();
      apex_json.write ('errorMessage', l_error_message);
      apex_json.close_object;

      apex_debug.error('Ajax SQL Errm: %s', sqlerrm);
      apex_debug.error('Ajax Error Backtrace: %s', DBMS_UTILITY.format_error_backtrace);

      RETURN l_result;
END ajax_func;
END IR_CHECKBOX_UTIL;
/
