class Article < ApplicationRecord
validates_presence_of :title, :content, :date, :author
end
