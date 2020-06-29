module UsersHelper
  # 引数で与えられたユーザーのGravatar画像を返す
  def gravatar_for(user, size: 80, class_name: 'gravatar')
    image_tag(gravatar_url(user, size: size), alt: user.name, class: class_name)
  end

  def gravatar_url(user, size: 80)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end
end
