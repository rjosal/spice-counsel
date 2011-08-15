#$LastChangedDate: 2010-06-10 11:52:25 -0700 (Thu, 10 Jun 2010) $
#$LastChangedBy: rjosal $

class User < ActiveRecord::Base
  has_many :ratings

  # validations
  validates_presence_of :name
  validates_uniqueness_of :email

  # actual hashing method
  def self.encrypt( password, salt )
    Digest::SHA1.hexdigest( password + salt )
  end
  
  # method to set hashed password
  def password=(password)
    return if password == '##hashed##'
    @password = password
    
    self.salt = User.random_string( 10 ) if self.salt.nil?
    self.hashed_password = User.encrypt( @password, self.salt )
  end
  
  def password
    '##hashed##'
  end
  
  def self.random_string (length)
    str = ""
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.upto(length) { |i| str << chars[rand(chars.size-1)] }
    str
  end

  # authenticate based on password and email
  # only grant access to active users
  def self.authenticate (email, password)
    return nil if email.nil? || password.nil? || email == '' || password == ''
    user = find_by_email(email)
    return nil if user.nil?
    if user.hashed_password == User.encrypt( password, user.salt )
      return user
    end
    nil
  end

  def self.top_by_ratings(limit = 3)
    conn = ActiveRecord::Base.connection
    res = []
    if conn
      conn.select_values("select u.id from users u, ratings ra where u.id = ra.user_id group by u.id order by count(*) desc limit #{limit}").each { |id| res << User.find(id) }
    end
    res
  end
end
