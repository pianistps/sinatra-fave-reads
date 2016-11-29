require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(:name => "test 123", :email => "test123@aol.com", :password => "test")
  end
  it 'can slug the name' do
    expect(@user.slug).to eq("test-123")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).name).to eq("test 123")
  end

  it 'has a secure password' do

    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("test")).to eq(@user)

  end
end
