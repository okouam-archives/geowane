(function(a){a.fn.pajinate=function(b){function k(b){new_page=parseInt(e.data(c))-1,a(b).siblings(".active_page").prev(".page_link").length==!0&&(o(b,new_page),m(new_page))}function l(b){new_page=parseInt(e.data(c))+1,a(b).siblings(".active_page").next(".page_link").length==!0&&(n(b,new_page),m(new_page))}function m(a){var f=e.data(d),g=!1;start_from=a*f,end_on=start_from+f,i.hide().slice(start_from,end_on).show(),h.find(b.nav_panel_id).children(".page_link[longdesc="+a+"]").addClass("active_page").siblings(".active_page").removeClass("active_page"),e.data(c,a),p()}function n(c,d){var e=d,f=a(c).siblings(".active_page");f.siblings(".page_link[longdesc="+e+"]").css("display")=="none"&&j.each(function(){a(this).children(".page_link").hide().slice(parseInt(e-b.num_page_links_to_display+1),e+1).show()})}function o(c,d){var e=d,f=a(c).siblings(".active_page");f.siblings(".page_link[longdesc="+e+"]").css("display")=="none"&&j.each(function(){a(this).children(".page_link").hide().slice(e,e+parseInt(b.num_page_links_to_display)).show()})}function p(){j.children(".page_link:visible").hasClass("last")?j.children(".more").hide():j.children(".more").show(),j.children(".page_link:visible").hasClass("first")?j.children(".less").hide():j.children(".less").show()}var c="current_page",d="items_per_page",e,f={item_container_id:".content",items_per_page:10,nav_panel_id:".page_navigation",num_page_links_to_display:20,start_page:0,nav_label_first:"First",nav_label_prev:"Prev",nav_label_next:"Next",nav_label_last:"Last"},b=a.extend(f,b),g,h,i,j;return this.each(function(){h=a(this),g=a(this).find(b.item_container_id),i=h.find(b.item_container_id).children(),e=h,e.data(c,0),e.data(d,b.items_per_page);var f=g.children().size(),q=Math.ceil(f/b.items_per_page),r='<span class="ellipse more">...</span>',s='<span class="ellipse less">...</span>',t='<a class="first_link" href="">'+b.nav_label_first+"</a>";t+='<a class="previous_link" href="">'+b.nav_label_prev+"</a>"+s;var u=0;while(q>u)t+='<a class="page_link" href="" longdesc="'+u+'">'+(u+1)+"</a>",u++;t+=r+'<a class="next_link" href="">'+b.nav_label_next+"</a>",t+='<a class="last_link" href="">'+b.nav_label_last+"</a>",j=h.find(b.nav_panel_id),j.html(t).each(function(){a(this).find(".page_link:first").addClass("first"),a(this).find(".page_link:last").addClass("last")}),j.children(".ellipse").hide(),j.find(".previous_link").next().next().addClass("active_page"),i.hide(),i.slice(0,e.data(d)).show();var v=h.children(b.nav_panel_id+":first").children(".page_link").size();b.num_page_links_to_display=Math.min(b.num_page_links_to_display,v),j.children(".page_link").hide(),j.each(function(){a(this).children(".page_link").slice(0,b.num_page_links_to_display).show()}),h.find(".first_link").click(function(b){b.preventDefault(),o(a(this),0),m(0)}),h.find(".last_link").click(function(b){b.preventDefault();var c=v-1;n(a(this),c),m(c)}),h.find(".previous_link").click(function(b){b.preventDefault(),k(a(this))}),h.find(".next_link").click(function(b){b.preventDefault(),l(a(this))}),h.find(".page_link").click(function(b){b.preventDefault(),m(a(this).attr("longdesc"))}),m(parseInt(b.start_page)),p()})}})(jQuery)