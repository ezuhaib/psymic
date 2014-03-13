class ReputationChangeObserver
  def update(changed_data)
    sash = changed_data[:merit_object].sash
    user = User.where(sash_id: sash.id).first
    user.update_attributes(points: user.points)
  end
end