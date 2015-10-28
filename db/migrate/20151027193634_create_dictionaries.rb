class CreateDictionaries < ActiveRecord::Migration
  def up
    create_table :dictionaries do |t|
      t.text :word, index: true
      t.text :meaning, null: true
      t.integer :count, null: false
      t.timestamps
    end

    File.open('public/dictionary.txt', 'r') do |f|
      f.each_line do |line|
        Dictionary.new({word: line.strip,meaning: '',count: 1}).save!
      end
    end
  end

  def down
    drop_table :dictionaries
  end
end
