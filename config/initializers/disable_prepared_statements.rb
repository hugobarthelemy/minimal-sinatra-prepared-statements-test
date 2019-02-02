ActiveRecord::Base.establish_connection(
  ActiveRecord::Base.remove_connection.merge(
    :prepared_statements => false
  )
)
