class RulesetsController < ApplicationController
  include Aegis::Controller
  layout "admin"

  def index
    @rulesets = Ruleset.all
  end

  def edit
    @ruleset = Ruleset.find(params[:id])
    @categories = Category.dropdown_items
  end

  def new
    ruleset = Ruleset.create(:name => "Ruleset #{Ruleset.count}")
    redirect_to edit_ruleset_path(ruleset)
  end

  def update
    @ruleset = Ruleset.find(params[:id])
    @ruleset.update_attribute(params[:ruleset])
    render :text => "ok"
  end

end