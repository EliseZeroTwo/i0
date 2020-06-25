# i0.wtf Backend & Frontend code

Simple Ruby "static" site

This is the source code I use to maintain my website at [i0.wtf](https://i0.wtf/).

This isn't really made for usage by others, I just wanted to make the code public, however this does work and adding new themes is pretty easy granted you have basic ruby knowledge. Also better things exist by far, I just wrote this for fun.

To run:
```shell script
ruby ./blog.rb
```

Markdown articles get read from `DIR_SPECIFIED_IN_CONFIG/articles` and their name and ID is taken from the file name with `-` replaced with spaces, like I said it's simple right? 
