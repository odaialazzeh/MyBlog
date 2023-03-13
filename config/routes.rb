Rails.application.routes.draw do
  root 'user#list'
  get 'user/show'
  get 'post/list'
  get 'posts/show'
end
