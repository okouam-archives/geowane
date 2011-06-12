require 'sinatra/base'
require 'json'
require 'rack/contrib/jsonp'

class Services::CategoryApi < Services::Base

  use Rack::JSONP

  before do
    content_type :json
  end

  get '/' do
    sql = %{
      SELECT categories.id, french, count(*) as count
      FROM categories
      JOIN tags ON tags.category_id = categories.id
      GROUP BY categories.id, french
    }
    Category.find_by_sql(sql).to_json
  end

end