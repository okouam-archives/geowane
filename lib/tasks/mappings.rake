namespace :geocms do

  desc "Create a classification for each category for all partners"
  task :classifications => :environment do
    Category.all.each do |category|
      Partner.all.each do |partner|
        @classification = Classification.create(:french => category.french, :partner => partner,:english => category.english, :icon => category.icon)
        @classification.categories << category
      end
    end
  end

end