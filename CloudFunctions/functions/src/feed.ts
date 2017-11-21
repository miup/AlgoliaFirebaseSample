import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import algolia from './algoliaProvider'
import firebaseModel from './firebaseModel'

class Feed {
  objectID: string
  _createdAt: number
  _updatedAt: number
  _geoloc: {
    lng: number
    lat: number
  }
  isLocationEnabled: boolean
  contentType: number
  contentID: string
  userID: string
  userName: string
  diary: firebaseModel.Diary | undefined
  photo: firebaseModel.Photo | undefined
  likes: {
    count: number
  }
  // likeIDs: string[]

  constructor(postID: string, post: firebaseModel.Post, user: firebaseModel.User, diary: firebaseModel.Diary | undefined, photo: firebaseModel.Photo | undefined) {
    this.objectID = postID
    this._geoloc = {
      lng: post.lng,
      lat: post.lat
    }
    this.userName = user.name
    this._createdAt = post._createdAt
    this._updatedAt = post._updatedAt
    this.isLocationEnabled = post.isLocationEnabled
    this.contentType = post.contentType
    this.contentID = post.contentID
    this.userID = post.userID
    this.diary = diary
    this.photo = photo
    this.likes = {
      count: post.likes.count
    }
  }
}

export const postCreated  = functions.database.ref('miup/AlgoliaFirebaseSample/v1/post/{postID}').onCreate(async event => {
  const firPost: firebaseModel.Post = event.data.val()
  const feedIndex = algolia.initIndex('feed')
  let user = await admin.database().ref(`miup/AlgoliaFirebaseSample/v1/user/${firPost.userID}`).once('value').then(snap => snap.val())
  switch (firPost.contentType) {
  case 1:
    let diary = await admin.database().ref(`miup/AlgoliaFirebaseSample/v1/diary/${firPost.contentID}`).once('value').then(snap => snap.val())
    let diaryFeed = new Feed(event.params!.postID, firPost, user, diary, undefined)
    return feedIndex.addObject(diaryFeed)
  case 2:
    let photo = await admin.database().ref(`miup/AlgoliaFirebaseSample/v1/photo/${firPost.contentID}`).once('value').then(snap => snap.val())
    let photoFeed = new Feed(event.params!.postID, firPost, user, undefined, photo)
    return feedIndex.addObject(photoFeed)
  default: return undefined
  }
})

export const postLiked = functions.database.ref('miup/AlgoliaFirebaseSample/v1/post/{postID}/likes/count').onUpdate(async event => {
  const postID = event.params!.postID
  const likeCount = event.data.val()
  algolia.initIndex('feed').partialUpdateObject({
    likes: {
      count: likeCount
    },
    objectID: postID
  }, (err, content) => {
    if (err) { console.error(err) }
  })
})
