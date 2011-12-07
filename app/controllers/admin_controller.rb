class AdminController < ApplicationController

  def dashboard
    Lighthouse.account = "codeifier"
    Lighthouse.token = "f86e43942cc4a4be839c216b67e041bcea074298"
    project = Lighthouse::Project.find(39487)
    @tickets = project.tickets(:q=>"updated:'since 100 days ago' sort:number").sort_by{|x| x.state}.reverse
    @tickets = @tickets.keep_if {|x| x.title =~ /#{params[:s][:name]}/i} if params[:s]
  end

end
