create or replace PACKAGE "IR_CHECKBOX_UTIL"
AS
   FUNCTION render_func ( p_dynamic_action   IN apex_plugin.t_dynamic_action,
                          p_plugin           IN apex_plugin.t_plugin) RETURN apex_plugin.t_dynamic_action_render_result;
   FUNCTION ajax_func (p_dynamic_action   IN apex_plugin.t_dynamic_action,
                          p_plugin           IN apex_plugin.t_plugin) RETURN apex_plugin.t_dynamic_action_ajax_result;
END IR_CHECKBOX_UTIL;
/
