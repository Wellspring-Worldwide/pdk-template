require 'json'
require 'yaml'

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
HIERA_ROOT = File.join(PROJECT_ROOT, 'spec/hiera')
METADATA = JSON.load(File.read(File.join(PROJECT_ROOT, 'metadata.json')))
MODULE_NAME = METADATA['name'].split('-')[-1]
FIXTURES = YAML.load_file(File.join(PROJECT_ROOT, '.fixtures.yml'))
MODULES = FIXTURES.fetch('fixtures', {}).fetch('symlinks', {})
FORGE_MODULES = FIXTURES.fetch('fixtures', {}).fetch('forge_modules', {})
REPOSITORIES = FIXTURES.fetch('fixtures', {}).fetch('repositories', {})
