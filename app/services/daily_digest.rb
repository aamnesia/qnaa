class Services::DailyDigest
  def send_digest
    return if Question.where(created_at: Date.yesterday.all_day).empty?

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
