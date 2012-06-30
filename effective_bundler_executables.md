What Is Bundler?
----------------
Bundler is a ruby gem loading system. It loads up all the relevant gems for your project, and ensures the versions are correct, before your app takes over.

How do I ensure that my executables are bundler aware?
------------------------------------------------------
When doing a bundle install (or just bundle), always add the option --binstubs. This will create binary wrappers in the bin/ folder of your project. 

Instead of executing commands directly like this:
  ```rake```

Execute the command command that is in the bin folder.
  ```./bin/rake```

Do I check these /bin/* files in?
---------------------------------
I usually git ignore them, but, according to the documentation, it's safe to check in.

I hate typing ./bin/rake every time!
------------------------------------
No problem. You can add a relative path like ./bin to your $PATH

* If you are using rbenv, just add ./bin to your path in your ~/.bashrc
* If you are using rvm, add ./bin into every .rvmrc