class AdminController < ApplicationController

  def dashboard

    @workflow_stats = ActiveRecord::Base.connection.execute %{
      SELECT * FROM crosstab(
        'SELECT row_name, category, value FROM workflow_chart',
        'SELECT distinct category FROM workflow_chart'
      ) as ct(
       Country text,
       "Invalid" int,
       "Audited" int,
       "Corrected" int,
       "New" int,
       "Field Checked" int
      );
    }

    @categorization_stats = ActiveRecord::Base.connection.execute %{
      SELECT * FROM crosstab(
        'SELECT row_name, category, value FROM categorization_chart',
        'SELECT distinct category FROM categorization_chart'
      ) as ct(
        country text,
        "Tagged" int,
        "Untagged" int
      );
     }

    @collector_stats = ActiveRecord::Base.connection.execute %{
      SELECT * FROM crosstab(
        'SELECT row_name, category, value FROM collector_chart',
        'SELECT distinct category FROM collector_chart'
      ) as ct(
        "User" text,
        "Invalid" int,
        "Audited" int,
        "Corrected" int,
        "New" int,
        "Field Checked" int
      );
    }

    @workflow_chart = HighChart.new('workflow_chart') do |f|
      create_standard_chart(f, "workflow", "Workflow Breakdown", 1100)
      f.x_axis(:categories => @workflow_stats.map {|x| x["country"] || "Unknown"})
      f.series(:name=>'Field Checked', :data=> @workflow_stats.map {|x| x["Field Checked"].to_i || 0})
      f.series(:name=>'Audited', :data=> @workflow_stats.map {|x| x["Audited"].to_i || 0})
      f.series(:name=>'Corrected', :data=> @workflow_stats.map {|x| x["Corrected"].to_i || 0})
      f.series(:name=>'Invalid', :data=> @workflow_stats.map {|x| x["Invalid"].to_i || 0})
      f.series(:name=>'New', :data=> @workflow_stats.map {|x| x["New"].to_i || 0})
    end

    @categorization_chart = HighChart.new('categorization_chart') do |f|
      create_standard_chart(f, "categorization", "Categorization Breakdown", 500)
      f.x_axis(:categories => @categorization_stats.map {|x| x["country"] || "Unknown"})
      f.series(:name=>'Tagged', :data=> @categorization_stats.map {|x| x["Tagged"].to_i || 0})
      f.series(:name=>'Untagged', :data=> @categorization_stats.map {|x| x["Untagged"].to_i || 0})
    end

    @collector_chart = HighChart.new('collector_chart') do |f|
      create_standard_chart(f, "collector", "Collector Breakdown", 3400)
      f.x_axis(:categories => @collector_stats.map {|x| x["User"] || "Unknown"})
      f.series(:name=>'Field Checked', :data=> @collector_stats.map {|x| x["Field Checked"].to_i || 0})
      f.series(:name=>'Audited', :data=> @collector_stats.map {|x| x["Audited"].to_i || 0})
      f.series(:name=>'Corrected', :data=> @collector_stats.map {|x| x["Corrected"].to_i || 0})
      f.series(:name=>'Invalid', :data=> @collector_stats.map {|x| x["Invalid"].to_i || 0})
      f.series(:name=>'New', :data=> @collector_stats.map {|x| x["New"].to_i || 0})
    end

  end

  def create_standard_chart(f, name, title, height)
      f.legend(:enabled => true, :reversed => true, margin: 20)
      f.credits(:enabled => false)
      f.chart(renderTo: name, defaultSeriesType: 'bar', width: 870, height: height)
    	f.title(text: title)
      f.y_axis(:min => 0, :title => {:text => ''})
      f.plot_options({bar: {dataLabels: {enabled: true}}})
  end

end
