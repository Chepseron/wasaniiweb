function findForm(id, type, entity) {
  event.preventDefault();
  if(type == 'entities'){
    var val = entity;

    $.get(
      "/artists/".concat(id).concat('/new_entity?entity_type=').concat(val),
      'script'
    );

  }else if(type == 'news_event_blog'){
    var val = entity;
    $.get(
      "/artists/".concat(id).concat('/new_news_event_blog?request=').concat(val),
      'script'
    );
  }
}

function findBusinessForm(id, type, entity) {
  event.preventDefault();
  if(type == 'entities'){
    var val = entity;

    $.get(
      "/businesses/".concat(id).concat('/new_entity?entity_type=').concat(val),
      'script'
    );

  }else if(type == 'news_event_blog'){
    var val = entity;
    $.get(
      "/businesses/".concat(id).concat('/new_news_event_blog?request=').concat(val),
      'script'
    );
  }
}

