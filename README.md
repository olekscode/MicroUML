# MicroUML

A UML model and an embedded DSL in Pharo

MicroUML is a project to support a small syntax to describe class diagram. 



## Example


```pharoscript
#AbstractSeries 
    + #name @ String 
    #numEpisodes @ Integer
=== 
#NovelSeries 
    --|> #AbstractSeries
    + #author @ String 
    + #Publisher @ String 
    + #read~{}
=== 
#ComicSeries 
    --|> #AbstractSeries 
    + #toonAuthor @ String
    
#storyAuthor @ String + #print~{}
=== 
#AnimeSeries
    --|> #AbstractSeries 
    + #director @ String 
    
#animators @ String
#voiceActors @ String + #play~{} <>---<'based on'> #ComicSeries
=== 
#ComicSeries     ---<'original'> #NovelSeries 
extent: 600 @ 400
```
