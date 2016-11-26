class GroupRepresenter
  def initiliaze(group)
    @group = group
  end

  def to_json
    { group_id: @group.id,
      name: @group.group_name,
      urlname: @group.urlname,
      city: @group.city,
      country_code: @group.country_code }.to_json
  end
end
