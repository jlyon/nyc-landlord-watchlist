# check that the userId specified owns the documents
@ownsDocument = (userId, doc) ->
  doc && doc.userId == userId

@ownsOrAdmin = (userId, doc) ->
  doc && (doc.userId == userId || Roles.userIsInRole(userId, ['admin']))
