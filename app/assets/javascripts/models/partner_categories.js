$.Class.extend('PartnerCategories',
{
  remove: function(categories, partner_id, callback) {
    $.ajax({
      url: "/partners/" + partner_id + "/partner_categories/collection_delete",
      type: "POST",
      data: {collection: categories},
      success: callback
    });
  },

  createMapping: function(partner_id, partner_category_id, category_id, callback) {
    $.ajax({
      url: "/partners/" + partner_id + "/partner_categories/" + partner_category_id + "/mappings",
      type: "POST",
      dataType: 'json',
      data: {mapping: {category_id: category_id}},
      success: callback
    });
  },

  removeMapping: function(partner_id, partner_category_id, mapping_id, callback) {
    $.ajax({
      type: 'POST',
      url: "/partners/" + partner_id + "/partner_categories/" + partner_category_id + "/mappings/" + mapping_id,
      dataType: 'json',
      data: {'_method': 'delete'},
      success: callback
    });
  }
},
{ /* no instance methods */ });