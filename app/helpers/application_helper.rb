module ApplicationHelper
  # 出席数をバーで表示する
  def show_iruinai_bar(project = @project)
    (iru_value, total_value) = iruinai_count(project.id)
    percent = (iru_value > 0 && total_value > 0)? 100 * iru_value / total_value : 0

    return progress_bar_with_iruinai(percent, :legend => "#{iru_value}/#{total_value}")
  end

  # 出席率を計算する
  def iruinai_count(project_id)
    ut = User.table_name
    mt = Member.table_name
    # プロジェクトメンバーの設定を取得する
    last_accesses = UserPreference.find(:all, :select => 'p.id, p.others',
              :joins => "as p left join users as u on u.id = p.user_id left join #{mt} as m on p.user_id = m.user_id",
              :conditions => ["u.type = ? and m.project_id = ?", 'User', project_id])
    # 最終ログイン日時が今日のユーザを数えて返す
    now = Date.today
    return last_accesses.count do |access|
      access[:last_access_on] && now.strftime('%Y%m%d') == access[:last_access_on].strftime('%Y%m%d')
    end, last_accesses.size
  end

  # 出席率表示用の割合表示
  def progress_bar_with_iruinai(pcts, options={})
    pcts = [pcts, pcts] unless pcts.is_a?(Array)
    pcts = pcts.collect(&:round)
    pcts[1] = pcts[1] - pcts[0]
    pcts << (100 - pcts[1] - pcts[0])
    width = options[:width] || '100px;'
    legend = options[:legend] || ''
    iru_color = ''
    inai_color = '#ffffff;'
    pcts1_style = "width: #{pcts[0]}%;"
    pcts1_style += " background-color: #{iru_color};" if iru_color.present?
    pcts2_style = "width: #{pcts[1]}%;"
    pcts3_style = "width: #{pcts[2]}%;"
    pcts3_style += " background-color: #{inai_color};" if inai_color.present?
    return content_tag('table',
      content_tag('tr',
        (pcts[0] > 0 ? content_tag('td', '', :style => pcts1_style, :class => 'closed') : ''.html_safe) +
        (pcts[1] > 0 ? content_tag('td', '', :style => pcts2_style, :class => 'done') : ''.html_safe) +
        (pcts[2] > 0 ? content_tag('td', '', :style => pcts3_style, :class => 'todo') : ''.html_safe) +
        (legend.present? ? content_tag('td', legend, :class => 'pourcent') : ''.html_safe)
      ), :class => 'progress', :style => "width: #{width};").html_safe
  end
end
