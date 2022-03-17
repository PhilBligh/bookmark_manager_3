require 'bookmark'
require_relative '../database_helpers'

describe Bookmark do
  describe '.all' do
    it 'returns all bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

      #Add the test data
      bookmark = Bookmark.create(url: 'http://www.google.com', title: 'Google')
      Bookmark.create(url: 'http://www.yahoo.com', title: 'Yahoo')
      Bookmark.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
      
      bookmarks = Bookmark.all
    
      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq bookmark.id 
      expect(bookmarks.first.title).to eq 'Google'
      expect(bookmarks.first.url).to eq 'http://www.google.com'
    end
  end

  describe '.create' do
    it 'creates a new bookmark' do
      bookmark = Bookmark.create(url: 'http://www.testbookmark.com', title: "Test Bookmark")
      persisted_data = persisted_data(id: bookmark.id)

      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data.first['id']
      expect(bookmark.title).to eq 'Test Bookmark'
      expect(bookmark.url).to eq 'http://www.testbookmark.com'
    end
  end

  describe '.delete' do
    it 'deletes the given bookmark' do
      bookmark = Bookmark.create(title: 'Google', url: 'http://www.google.com')
      
      Bookmark.delete(id: bookmark.id)
      expect(Bookmark.all.length).to eq 0
    end
  end

  describe '.update' do
    it 'updates the bookmark with new data' do
      bookmark = Bookmark.create(title: "Yahoo", url: "http://www.yahoo.com")
      updated_bookmark = Bookmark.update(id: bookmark.id, url: "http://www.yahoor.com", title: 'Yahoor')

      expect(updated_bookmark).to be_a Bookmark
      expect(updated_bookmark.id).to eq bookmark.id
      expect(updated_bookmark.title).to eq 'Yahoor'
      expect(updated_bookmark.url).to eq 'http://www.yahoor.com'
    end
  end

  describe '.find' do
    it 'returns the requested bookmark object' do
      bookmark = Bookmark.create(title: "Yahoo", url: "http://www.yahoo.com")
      
      result = Bookmark.find(id: bookmark.id)

      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq 'Yahoo'
      expect(result.url).to eq 'http://www.yahoo.com'
    end
  end

  describe '.create' do
    it 'does not create a new bookmark if the URL is not valid' do
      Bookmark.create(url: 'not a real bookmark', title: 'not a real bookmark')
      expect(Bookmark.all).to be_empty
    end
  end

  describe '#comments' do
  it 'returns a list of comments on the bookmark' do
    bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
    DatabaseConnection.query(
      "INSERT INTO comments (id, text, bookmark_id) VALUES(1, 'Test comment', $1)",
      [bookmark.id])

    comment = bookmark.comments.first

    expect(comment['text']).to eq 'Test comment'
  end
end


end