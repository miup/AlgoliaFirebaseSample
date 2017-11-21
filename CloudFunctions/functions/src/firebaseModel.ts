declare namespace firebaseModel {
  interface Relation {
    count: number
  }
  interface Salada {
    _createdAt: number
    _updatedAt: number
  }

  interface User extends Salada {
    name: string
    posts: Relation
    image?: File
    follower: Relation
    followee: Relation
  }

  interface File {
    mimeType: string
    name: string
    url: string
  }

  interface Post extends Salada {
    lng: number
    lat: number
    isLocationEnabled: boolean
    contentType: number
    contentID: string
    userID: string
    likes: Relation
  }

  interface Diary extends Salada {
    title: string
    detail: string
    image: File
  }

  interface Photo extends Salada {
    image: File
  }
}
export default firebaseModel