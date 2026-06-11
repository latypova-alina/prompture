class CreateAudioPrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :audio_prompts do |t|
      t.text :prompt, null: false
      t.references :video_prompt, null: false, foreign_key: true

      t.timestamps
    end
  end
end
