json.extract! schedule, :id, :start_time, :end_time, :branch_id, :user_id, :user_only, :branch_only, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)
