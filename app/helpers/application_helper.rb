module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return nil if current_user.nil?

    edit = link_to('Edit', url_for([:edit, item]), class: 'btn btn-primary')

    if admin_user
      del = link_to('Destroy', item, method: :delete,
                                     data: { confirm: 'Are you sure?' },
                                     class: 'btn btn-danger')
    end

    raw("#{edit} #{del}")
  end
end
