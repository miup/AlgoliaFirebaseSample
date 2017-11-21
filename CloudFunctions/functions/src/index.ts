import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'
import * as feed from './feed'
import * as user from './user'

admin.initializeApp(functions.config().firebase!)

export const createFeed = feed.postCreated
export const updateFeedLikeCount = feed.postLiked
export const createUser = user.userCreated
export const updateFollowerCount = user.userIsFollowed
export const updateFolloweeCount = user.userFollowed
export const updatePostCount = user.userPosted
