class CreateCartoonScripts < ActiveRecord::Migration[8.0]
  def change
    create_table :video_prompts do |t|
      t.text :prompt

      t.timestamps
    end

    create_table :image_prompts do |t|
      t.text :prompt

      t.timestamps
    end

    create_table :scripts do |t|
      t.text :script_text, null: false
      t.references :video_prompt, foreign_key: true
      t.references :image_prompt, foreign_key: true

      t.timestamps
    end
  end
end
