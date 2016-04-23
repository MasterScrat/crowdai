class SubmissionGraderJob < BaseJob
  queue_as :default

  def perform(*args)
    @logger.info("grader running for: #{args[0]}")
    Grader.new.grade(args[0][:submission_id])
  end


  def s3_expiring_url(s3_key)
    s3_file_obj = Aws::S3::Object.new(bucket_name: ENV['AWS_S3_BUCKET'], key: s3_key)
    url = s3_file_obj.presigned_url(:get, expires_in: 3600)
  end

end


# /api/v1/plantvillage_evaluation?submission_id=234&user_submission_url=https://s3.eu-central-1.amazonaws.com/crowdai-prd/submission_files/d1aa84ea-8e18-4109-ad1a-e74c65b33d05/synthetic_submission.csv
