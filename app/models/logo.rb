class Logo < ActiveRecord::Base
  mount_uploader :image, LogoUploader
end
