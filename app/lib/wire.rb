module Wire


  ##############################################
  # Notification Functions
  ##############################################

  #The notify function accepts these values as target:
  #    user_id
  #    a symbol for target role
  # It is using the activerecord-import gem to speed up inserting large number of queries inside database.
  # If :alt notification is provided, notifier will replace the old_notifications and make use of the counter
  # if no :alt notification is provided , a new notification will be made of the given type
  # Remember that the counter is advanced at the model level and isn't touched in this function
  # Currently notifications contain hard links, but these are passing through the liquid templating engine so
  #     that when in future a standard liquid syntax is developed for public use, the same might be integrate over here
  #     in a snap.
  #todo add ability to notify to an array of user_ids
  #todo return messages: success/failed/3 notifications sent etc
  #todo make user.notify! type function if required.

  def notify(target,text,tag,scope,hsh={})

    if target.class == Fixnum
        @old_notification = Notification.where(:user_id=>target,:tag=>tag,:scope=>scope).first
        @text = Liquid::Template.parse(text).render
        if @old_notification && @old_notification.counter >= 1 && hsh[:alt] #Compound Notification
          @alt = Liquid::Template.parse(hsh[:alt]).render('count'=> "<span class='badge'>#{@old_notification.counter+1}</span>")
          @old_notification.update_attributes(:text=>@alt,:counter=>counter = @old_notification.counter + 1)
        elsif @old_notification && @old_notification.counter == 0 && hsh [:alt] #Ovewriting Notification
          @old_notification.update_attributes(:text=>@text,:counter=>counter = @old_notification.counter + 1)
        else #NewEntry if no :alt provided or if notification being sent for the first time
          Notification.create!(:user_id=>target,:text=>@text, :tag=> tag,:scope=>scope,:counter=>1)
      end

    elsif target.class == Symbol
      @targets = Role.find_by_name(target.to_s.singularize).user_ids
      @notifications_bulk = []
      @targets.each do |target|
        @notifications_bulk << Notification.new(:user_id=>target,:title=>notification, :category=>type)
      end
      Notification.import @notifications_bulk
      end
  end

  def denotify(targer,text,tag,scope)
    @notification = Notification.where(:user_id=>target,:tag=>tag,:scope=>scope)
    if @notification.count == 0 || @notification.count == 1
      @notification.destroy
    else
      @notification.count -= 1
      @notification.save
    end
  end


end