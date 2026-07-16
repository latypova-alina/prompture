class RenameScriptsToScenes < ActiveRecord::Migration[8.0]
  def change
    rename_table :scripts, :scenes
    rename_column :scenes, :script_text, :scene_text
  end
end
