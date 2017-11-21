import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import algolia from './algoliaProvider'
import firebaseModel from './firebaseModel'

class User {
  objectID: string
  name: string
  image?: firebaseModel.File
  posts: {
    count: number
  }

  follower: {
    count: number
  }

  followee: {
    count: number
  }

  constructor(userID: string, user: firebaseModel.User) {
    this.objectID = userID
    this.name = user.name
    this.posts = user.posts
    this.image = user.image
    this.follower = user.follower
    this.followee = user.followee
  }
}

export const userCreated = functions.database.ref('miup/AlgoliaFirebaseSample/v1/user/{userID}').onCreate(async event => {
  let userID = event.params!.userID
  let firUser = await admin.database().ref(`miup/AlgoliaFirebaseSample/v1/user/${userID}`).once('value').then(snap => snap.val())
  let userIndex = algolia.initIndex('user')
  let user = new User(userID, firUser)
  return userIndex.addObject(user)
})

// an user is followed by other user.
export const userIsFollowed = functions.database.ref('miup/AlgoliaFirebaseSample/v1/user/{userID}/follower/count').onUpdate(async event => {
  const userID = event.params!.userID
  const followerCount = event.data.val()
  algolia.initIndex('user').partialUpdateObject({
    follower: {
      count: followerCount
    },
    objectID: userID
  }, (err, content) => {
    if (err) { console.error(err) }
  })
})

/// an user followed other user.
export const userFollowed = functions.database.ref('miup/AlgoliaFirebaseSample/v1/user/{userID}/followee/count').onUpdate(async event => {
  const userID = event.params!.userID
  const followeeCount = event.data.val()
  algolia.initIndex('user').partialUpdateObject({
    followee: {
      count: followeeCount
    },
    objectID: userID
  }, (err, content) => {
    if (err) { console.error(err) }
  })
})

export const userPosted = functions.database.ref('miup/AlgoliaFirebaseSample/v1/user/{userID}/posts/count').onUpdate(async event => {
  const userID = event.params!.userID
  const postCount = event.data.val()
  algolia.initIndex('user').partialUpdateObject({
    posts: {
      count: postCount
    },
    objectID: userID
  }, (err, content) => {
    if (err) { console.error(err) }
  })
})
