class AdminController < ApplicationController

  def dashboard
    Lighthouse.account = "codeifier"
    Lighthouse.token = "f86e43942cc4a4be839c216b67e041bcea074298"
    project = Lighthouse::Project.find(39487)
    @resolved = project.tickets(:q=>"state:resolved updated:'since 7 days ago' sort:number")
    @outstanding = project.tickets(:q=>"state:new state:open state:review state:backlog updated:'since 15 days ago'").sort_by{|x| x.state}.reverse
  end

end
