class IruinaiHook < Redmine::Hook::ViewListener
  render_on :view_issues_sidebar_planning_bottom, :partial => 'iruinai/sidebar'
end
