package com.aol.api
{
    public class Quotes
    {
        public static function get quote():String{
            if(!_quotes)
            {
                _quotes = data.split("|");
            }
            var idx:int = Math.floor(_quotes.length * Math.random());
            return _quotes[idx];
        }
        private static var _quotes:Array;
        private static const data:String = 
"\"What a cruel thing is war: to separate and destroy families and  friends, and mar the purest joys and happiness God has granted us  in this world; to fill our hearts with hatred instead of love for  our neighbors, and to devastate the fair face of this beautiful  world.\"<br> -- Robert E. Lee, letter to his wife, 1864" +
"|\"Pardon him, Theodotus; he is a barbarian, and thinks that the  customs of his tribe and island are the laws of nature.\" <br> -- George Bernard Shaw" +
"|\"The competent programmer is fully aware of the limited size of  his own skull. He therefore approaches his task with full  humility, and avoids clever tricks like the plague.\"<br> -- Edsger W. Dijkstra, EWD340" +
"|\"Ignorance simplifies ANY problem.\"<br> -- R. Lucke" +
"|\"The chain reaction of evil<br> -- wars producing more wars<br> -- must be broken, or we shall be plunged into the dark abyss of  annihilation.\"<br> -- Martin Luther King, Jr" +
"|\"Before the war is ended, the war party assumes the divine right to denounce and silence all opposition to war as unpatriotic  and cowardly.\"<br> -- Senator Robert M. La Follette" +
"|\"After every 'victory' you have more enemies.\"<br> -- Jeanette Winterson" +
"|\"Our children are not born to hate, they are raised to hate.\"<br> -- Thomas della Peruta" +
"|\"The shepherd always tries to persuade the sheep that their interests and his own are the same.\"<br> -- Marie Beyle" +
"|\"I hate those men who would send into war youth to fight and  die for them; the pride and cowardice of those old men, making their wars that boys must die.\"<br> -- Mary Roberts Rinehart" +
"|\"Guard against the impostures of pretended patriotism.\"<br> -- George Washington" +
"|\"The de facto role of the US armed forces will be to keep the world safe for our economy and open to our cultural assault.\"<br> -- Major Ralph Peters, US Military" +
"|\"Patriotism means to stand by the country. It does not mean to stand by the president or any other public official...\"<br> -- Theodore Roosevelt" +
"|\"The worst crimes were dared by a few, willed by more and tolerated by all.\"<br> -- Tacitus" +
"|\"Military glory<br> -- that attractive rainbow, that rises in showers of blood<br> -- that serpent's eye, that charms to destroy...\"<br> -- Abraham Lincoln" +
"|\"Only a free and unrestrained press can effectively expose deception in government.\" <br> -- Hugo Black, Supreme Court Justice" +
"|\"War is fear cloaked in courage.\"<br> -- General William Westmoreland" +
"|\"Because I do it with one small ship, I am called a terrorist.  You do it with a whole fleet and are called an emperor.\"<br> -- A pirate, from St. Augustine's \"City of God\"" +
"|\"What is morally wrong can never be advantageous, even when it enables you to make some gain that you believe to be to your advantage.\"<br> -- Marcus Tullius Cicero" +
"|\"Everybody's worried about stopping terrorism. Well, there's a really easy way: stop participating in it.\"<br> -- Noam Chomsky" +
"|\"It is far easier to make war than peace.\"<br> -- Georges Clemenceau" +
"|\"The belief in the possibility of a short decisive war appears to be one of the most ancient and dangerous of human illusions.\"<br> -- Robert Lynd" +
"|\"Of all the enemies to public liberty, war is perhaps the most  to be dreaded because it comprises and develops the germ of  every other.\"<br> -- James Madison" +
"|\"War doesn't make boys men, it makes men dead.\"<br> -- Ken Gillespie" +
"|\"Every nation has its war party. It is not the party of democracy. It is the party of autocracy. It seeks to dominate absolutely.\"<br> -- Senator Robert M. La Follette" +
"|\"It is the job of thinking people not to be on the side of the executioners.\"<br> -- Albert Camus" +
"|\"Paramount among the responsibilities of a free press is the duty to prevent any part of the government from deceiving the  people.\"<br> -- Hugo Black, Supreme Court Justice" +
"|\"Liberty and democracy become unholy when their hands are dyed red with innocent blood.\"<br> -- Mahatma Gandhi" +
"|\"Peace is constructed, not fought for.\"<br> -- Brent Davis" +
"|\"In this war – as in others – I am less interested in honoring the dead than in preventing the dead.\"<br> -- Butler Shaffer" +
"|\"It is only those who have neither fired a shot nor heard the shrieks and groans of the wounded who cry aloud for blood..War is hell.\"<br> -- General William Tecumseh Sherman" +
"|\"It is dangerous to be right when the government is wrong.\"<br> -- Voltaire" +
"|\"The worst barbarity of war is that it forces men collectively to commit acts against which individually they would revolt with their whole being.\"<br> -- Ellen Key" +
"|\"Some men, in order to prevent the supposed intentions of their adversaries, have committed the most enormous cruelties.\"<br> -- Clearchus, in Xenophon" +
"|\"[War] might be avoidable were more emphasis placed on the training to social interest, less on the attainment of egotistical grandeur.\"<br> -- Lydia Sicher" +
"|\"Look at you in war. There has never been a just one, never an honorable one, on the part of the instigator of the war.\"<br> -- Mark Twain" +
"|\"Everything secret degenerates, even the administration of  justice.\"<br> -- Lord Acton" +
"|\"Military justice is to justice what military music is to music.\"<br> -- Groucho Marx" +
"|\"Violence is the last refuge of the incompetent.\"<br> -- Issac Asimov" +
"|\"A state of war only serves as an excuse for domestic tyranny.\"<br> -- Aleksandr Solzhenitsyn" +
"|\"War is not the continuation of politics with different means,  it is the greatest mass-crime perpetrated on the community of  man.\"<br> -- Alfred Adler" +
"|\"We will not learn how to live together in peace by killing each other's children.\"<br> -- Jimmy Carter" +
"|\"The dangerous patriot ... is a defender of militarism and its ideals of war and glory.\"<br> -- Colonel James A. Donovan, Marine Corps" +
"|\"To jaw-jaw is always better than to war-war.\" <br> -- Winston Churchill" +
"|\"Man has no right to kill his brother. It is no excuse that he does so in uniform: he only adds the infamy of servitude to the crime of murder.\"<br> -- Percy Bysshe Shelley" +
"|\"Is it not a strange blindness on our part to teach publicly the techniques of warfare and to reward with medals those who prove to be the most adroit killers?\"<br> -- Marquis de Sade" +
"|\"The cry has been that when war is declared, all opposition should be hushed. A sentiment more unworthy of a free country could hardly be propagated.\"<br> -- William Ellery Channing" +
"|\"Our government has kept us in a perpetual state of fear - kept us in a continuous stampede of patriotic fervor - with the cry of grave national emergency.\"<br> -- General Douglas MacArthur" +
"|\"The internet is not something you just dump something on. It's  not a truck. It's a series of tubes!\" <br> -- Sen. Ted Stevens, chairman of the United States Senate     Committee on Commerce, Science and Transportation" +
"|\"Elegance is not a dispensable luxury but a factor that decides  between success and failure.\"<br> -- Edsger Dijkstra " +
"|\"It's wonderful to be here in the great state of Chicago.\"<br> -- Dan Quayle" +
"|\"If Al Gore invented the Internet, I invented spell check.\"<br> -- Dan Quayle " +
"|\"My current job sucks so hard, black holes are going green with envy.\"<br> -- Liz Kimber, in borland.*.*.*.delphi.win32" +
"|\"I was playing poker the other night... with Tarot cards. I got a full house and 4 people died.\"<br> -- Steven Wright" +
"|\"'Everything you say is boring and incomprehensible', she said,  'but that alone doesn't make it true.'\"<br> -- Franz Kafka" +
"|\"Should array indices start at 0 or 1? My compromise of 0.5 was rejected without, I thought, proper consideration.\"<br> -- Stan Kelly-Bootle" +
"|\"If electricity comes from electrons, does that mean that  morality comes from morons?\"<br> -- Unknown" +
"|\"The company doesn't tell me what to say, and I don't tell themwhere to stick it.\"<br> -- Unknown" +
"|\"The only way to combat criminals is by not voting for them.\"<br> -- Dayton Allen" +
"|\"A camel is a horse designed by a committee\"<br> -- Unknown" +
"|\"I'm not under the alkafluence of inkahol that some thinkle  peep I am. It's just the drunker I sit here the longer I get.\"<br> -- Unknown" +
"|\"Sex is like air.  It's only a big deal if you can't get any.\"<br> -- Unknown" +
"|\"Support your local Search and Rescue unit<br> -- get lost.\"<br> -- Unknown" +
"|\"A great many people think they are thinking when they are merely rearranging their prejudices.\"<br> -- William James" +
"|\"The whole problem with the world is that fools and fanatics are always so certain of themselves, but wiser people so full of  doubts.\"<br> -- Bertrand Russell" +
"|\"The bureaucracy is expanding to meet the needs of an expanding bureaucracy.\"<br> -- Unknown" +
"|\"I took a course in speed reading and was able to read War and Peace in twenty minutes.  It's about Russia.\"<br> -- Woody Allen" +
"|\"Jesus may love you, but I think you're garbage wrapped in skin.\"<br> -- Michael O'Donohugh" +
"|\"Ah, you know the type.  They like to blame it all on the Jews  or the Blacks, 'cause if they couldn't, they'd have to wake up to the fact that life's one big, scary, glorious, complex and ultimately unfathomable crapshoot<br> -- and the only reason THEY can't seem to keep up is they're a bunch of misfits and losers.\"<br> -- An analysis of Neo-Nazis, from \"The Badger\" comic" +
"|\"Subtlety is the art of saying what you think and getting out of the way before it is understood.\"<br> -- Unknown" +
"|\"Tact is the ability to tell a man he has an open mind when he  has a hole in his head.\"<br> -- Unknown" +
"|\"The study of non-linear physics is like the study of non-elephant biology.\"<br> -- Unknown" +
"|\"I do not have a body, I am a body.\"<br> -- Unknown" +
"|\"If people are good only because they fear punishment, and hope for  reward, then we are a sorry lot indeed.\"<br> -- Albert Einstein" +
"|\"A radioactive cat has eighteen half-lives.\"<br> -- Unknown" +
"|\"Clothes make the man.  Naked people have little or no influence on society.\"<br> -- Mark Twain" +
"|\"I doubt, therefore I might be.\"<br> -- Unknown" +
"|\"If you believe in telekinesis, raise my hand.\"<br> -- Unknown" +
"|\"If you take something apart and put it back together again enough times, you will eventually have enough parts left over to build a second one.\"<br> -- The law of inanimate reproduction" +
"|\"I have spoken many a word, therefore, it is fact.\"<br> -- Eric the Verbose" +
"|\"Puritanism: The haunting fear that someone, somewhere, may be happy.\"<br> -- H. L. Mencken" +
"|\"Roses are #FF0000 Violets are #0000FF All my base are belong to you!\"<br> -- Geek Valentine T-shirt at ThinkGeek  " +
"|\"As nightfall does not come at once, neither does oppression. In  both instances, there is a twilight when everything remains  unchanged. And it is in such twilight that we all must be most aware of change in the air — however slight — lest we become unwitting victims of the darkness.\" <br> -- Supreme Court Justice William O. Douglas" +
"|\"The surest way to corrupt a youth is to instruct him to hold in higher esteem those who think alike than those who think  differently\"<br> -- Friedrich Nietzsche" +
"|\"Conservatives are not necessarily stupid, but most stupid people are conservatives\"<br> -- John Stuart Mill" +
"|\"Throughout American history, the government has said we're in an  unprecedented crisis and that we must live without civil  liberties until the crisis is over. It's a hoax.\" <br> -- Yale Kamisar, 1990" +
"|\"Quoting Coulter is kind of like quoting Joe McCarthy; no doubt it does well when you're pandering to a group of like-minded hate  mongerers, but it earns you a well-deserved reputation as a vicious, mean-spirited airhead and intellecual lightweight in more analytical and dispassionate circles.\"<br> -- Mark Vaughan in borland.public.off-topic" +
"|\"Under conditions of competion, standards are set by the morally least reputable agent.\"<br> -- philosopher/economist John Stuart Mill" +
"|\"A terrorist is someone who has a bomb, but doesn't have an air force.\"<br> -- William Blum" +
"|\"You cannot depend on your eyes when your imagination is out of focus.\"<br> -- Mark Twain" +
"|\"Once you've written TBicycle, you never forget how.\"<br> -- Oliver Townshend in b.p.d.n-t. " +
"|\"When the rich think about the poor, they have poor ideas.\"<br> -- Evita Peron " +
"|\"Any fool can criticize, condemn, and complain - and most  fools do.\"<br> -- Dale Carnegie" +
"|\"Real punks help little old ladies across the street because it shocks more people than if they spit on the sidewalk.\"<br> -- Unknown" +
"|\"If you can read this you're not aiming in the right direction.\"<br> -- Toilet-ceiling graffiti" +
"|\"Getting an education was a bit like a communicable sexual disease.  It made you unsuitable for a lot of jobs and then you had the urge to pass it on.\"<br> -- Terry Pratchett, Hogfather" +
"|\"To understand a man you should walk a mile in his shoes. If what  he says still bothers you that's ok because you'll be a mile away  from him and you'll have his shoes.\"<br> -- Unknown" +
"|\"I'm trying to see things from your point of view but I can't get  my head that far up my ass.\" --- Unknown" +
"|\"Early to rise, Early to bed, Makes a man healthy but socially  dead.\"<br> -- The Warner Brothers (Animaniacs)" +
"|\"I hope life isn't a big joke ... because I don't get it.\" <br> -- Unknown" +
"|\"I'd stop eating chocolate, but I'm no quitter.\"<br> -- Unknown" +
"|\"I'm so poor I can't even pay attention.\"<br> -- Unknown" +
"|\"It's dangerous to underestimate the intelligence of a customer who grew a business that's successful enough to require a large and complex set of software\"<br> -- Grady Booch" +
"|\"A physicist is an atom's way of knowing about atoms.\"<br> -- George Wald" +
"|\"It's the liberal bias. The press is liberally biased to the  right.\"<br> -- Ken de Camargo" +
"|\"83.7% of all statistics are made up\" - Stephen Wright" +
"|\"That is the saving grace of humor, if you fail no one is laughing  at you.\"<br> -- A. Whitney Brown" +
"|\"Humor is the only test of gravity, and gravity of humor; for a  subject which will not bear raillery is suspicious, and a jest  which will not bear serious examination is false wit.\" <br> -- Aristotle (384 BC-322 BC)" +
"|\"All I need to make a comedy is a park, a policeman and a pretty  girl.\"<br> -- Charlie Chaplin (1889-1977), in My Autobiography (1964)" +
"|\"Total absence of humor renders life impossible.\"<br> -- Colette (1873-1954), Chance Acquaintances, 1952" +
"|\"Humor is always based on a modicum of truth. Have you ever heard  a joke about a father-in-law?\"<br> -- Dick Clark" +
"|\"A sense of humor is part of the art of leadership, of getting  along with people, of getting things done.\" <br> -- Dwight D. Eisenhower (1890-1969)" +
"|\"Analyzing humor is like dissecting a frog. Few people are  interested and the frog dies of it.\" <br> -- E. B. White (1899-1985)" +
"|\"Humor is by far the most significant activity of the human  brain.\"<br> -- Edward De Bono" +
"|\"The world is a tragedy to those who feel, but a comedy to those who think.\"<br> -- Horace Walpole (1717-1797)" +
"|\"If there’s one thing I know it’s God does love a good joke.\"<br> -- Hugh Elliott, Standing Room Only weblog, 05-01-04" +
"|\"The only rules comedy can tolerate are those of taste, and the  only limitations those of libel.\"<br> -- James Thurber (1894-1961)" +
"|\"The wit makes fun of other persons; the satirist makes fun of  the world; the humorist makes fun of himself.\" <br> -- James Thurber (1894-1961),     in Edward R. Murrow television interview" +
"|\"Where humor is concerned there are no standards - no one can  say what is good or bad, although you can be sure that everyone  will.\"<br> -- John Kenneth Galbraith (1908-2006)" +
"|\"One doesn't have a sense of humor. It has you.\"<br> -- Larry Gelbart" +
"|\"Humor is the great thing, the saving thing. The minute it crops  up, all our irritations and resentments slip away and a sunny  spirit takes their place.\"<br> -- Mark Twain (1835-1910)" +
"|\"Humor is a rubber sword - it allows you to make a point without  drawing blood.\"<br> -- Mary Hirsch" +
"|\"Humor is just another defense against the universe.\"<br> -- Mel Brooks (1926- )" +
"|\"Comedy is simply a funny way of being serious.\"<br> --  Peter Ustinov (1921-2004)" +
"|\"Comedy is nothing more than tragedy deferred.\"<br> -- Pico Iyer, Time" +
"|\"Wit makes its own welcome and levels all distinctions.\"<br> -- Ralph Waldo Emerson (1803-1882)" +
"|\"Defining and analyzing humor is a pastime of humorless people.\"<br> -- Robert Benchley (1889 - 1945)" +
"|\"Humor is also a way of saying something serious.\"<br> -- T. S. Eliot (1888 - 1965)" +
"|\"There's no trick to being a humorist when you have the whole  government working for you.\"<br> -- Will Rogers (1879-1935)       " +
"|\"Politicians are like diapers. They should be changed often, and  for the same reason.\"<br> -- Anonymous" +
"|\"Small minds run in the same gutter.\"<br> -- Alfred E. Neuman" +
"|\"Programming today is a race between software engineers striving  to build bigger and better idiot-proof programs, and the Universe trying to produce bigger and better idiots. So far, the Universe  is winning.\"<br> -- Rich Cook" +
"|\"Computer dating is fine, if you're a computer.\"<br> -- Rita May Brown" +
"|\"All sorts of computer errors are now turning up. You'd be  surprised to know the number of doctors who claim they are  treating pregnant men.\"<br> -- Isaac Asimov" +
"|\"To err is human, but to really foul things up you need a  computer.\"<br> -- Paul Ehrlich" +
"|\"The trouble with the Internet is that it's replacing  masturbation as a leisure activity.\"<br> -- Patrick Murray" +
"|\"Beware of computer programmers that carry screwdrivers.\"<br> -- Leonard Brandwein" +
"|\"UNIX is basically a simple operating system, but you have to be  a genius to understand the simplicity.\"<br> -- Dennis Ritchie" +
"|\"The perfect computer has been developed. You just feed in your problems and they never come out again.\"<br> -- Al Goodman" +
"|\"The most overlooked advantage of owning a computer is that if  they foul up there's no law against whacking them around a bit.\"<br> -- Eric Porterfield" +
"|\"Computers make it easier to do a lot of things, but most of the  things they make it easier to do don't need to be done.\" <br> -- Andy Rooney" +
"|\"Computer Science is no more about computers than astronomy is  about telescopes\"<br> -- Edsger W. Dijkstra" +
"|\"The great thing about a computer notebook is that no matter how  much you stuff into it, it doesn't get bigger or heavier.\" <br> -- Bill Gates" +
"|\"Not even computers will replace committees, because committees  buy computers.\"<br> -- Unknown" +
"|\"I do not fear computers. I fear the lack of them.\" <br> -- Isaac Asimov" +
"|\"Computers can figure out all kinds of problems, except the  things in the world that just don't add up.\"<br> -- James Magary" +
"|\"In all large corporations, there is a pervasive fear that  someone, somewhere is having fun with a computer on company time.  Networks help alleviate that fear.\"<br> -- John C. Dvorak" +
"|\"Imagine if every Thursday your shoes exploded if you tied them  the usual way. This happens to us all the time with computers,  and nobody thinks of complaining.\"<br> -- Jeff Raskin" +
"|\"If computers get too powerful, we can organize them into a  committee<br> -- that will do them in.\"<br> -- Bradley's Bromide" +
"|\"The most likely way for the world to be destroyed, most experts  agree, is by accident. That's where we come in; we're computer  professionals. We cause accidents.\"<br> -- Nathaniel Borenstein" +
"|\"To err is human<br> -- and to blame it on a computer is even more  so.\"<br> -- Robert Orben" +
"|\"If the automobile had followed the same development cycle as  the computer, a Rolls-Royce would today cost $100, get a  million miles per gallon, and explode once a year, killing  everyone inside.\"<br> -- Robert X. Cringely" +
"|\"If you put tomfoolery into a computer, nothing comes out of it  but tomfoolery. But this tomfoolery, having passed through a  very expensive machine, is somehow enobled and no-one dares  criticize it.\"<br> -- Pierre Gallois" +
"|\"Descended from the apes? Let us hope that it is not true. But  if it is, let us pray that it may not become generally known.\"<br> -- FA Montagu" +
"|\"I am an expert of electricity. My father occupied the chair of applied electricity at the state prison.\"<br> -- WC Fields" +
"|\"My advice to you is get married: if you find a good wife you'll  be happy; if not, you'll become a philosopher.\"<br> -- Socrates" +
"|\"An intellectual is someone who has found something more  interesting than sex.\"<br> -- Edgar Wallace" +
"|\"You ask me if I keep a notebook to record my great ideas. I've  only ever had one.\"<br> -- Albert Einstein" +
"|\"Only one man ever understood me, and he didn't understand me.\"<br> -- GW Hegel" +
"|\"Chaos Theory is a new theory invented by scientists panicked  by the thought that the public were beginning to understand  the old ones.\"<br> -- Mike Barfield" +
"|\"The secret of creativity is knowing how to hide your sources.\"<br> -- Albert Einstein" +
"|\"Louis Pasteur's theory of germs is ridiculous fiction.\"<br> -- Pierre Pachet, Professor of Physiology at Toulouse, 1872" +
"|\"The wireless music box has no imaginable commercial value. Who  would pay for a message sent to nobody in particular?\" <br> -- David Sarnoff's associates in response to his urging for     investment in the radio in the 1920s" +
"|\"Researchers have discovered that chocolate produces some of the same reactions in the brain as marijuana. The researchers also  discovered other similarities between the two but can't remember what they are.\"<br> -- Matt Lauer on NBC's Today Show " +
"|\"If it weren't for electricity we'd all be watching television by candlelight.\"<br> -- George Gobel" +
"|\"USA Today has come out with a new survey: Apparently three out  of four people make up 75 percent of the population.\" <br> -- David Letterman" +
"|\"In ancient times they had no statistics so they had to fall back  on lies.\"<br> -- Stephen Leacock" +
"|\"Ketchup left overnight on dinner plates has a longer half-life  than radioactive waste.\"<br> -- Wes Smith" +
"|\"Biologically speaking, if something bites you it's more likely  to be female.\"<br> -- Desmond Morris" +
"|\"When I die I'm going to leave my body to science fiction.\"<br> -- Steven Wright" +
"|\"Inanimate objects can be classified scientifically into three  major categories; those that don't work, those that break down  and those that get lost.\"<br> -- Russell Baker" +
"|\"Heaven is an American salary, a Chinese cook, an English house,  and a Japanese wife. Hell is defined as having a Chinese salary, an English cook, a Japanese house, and an American wife.\"<br> -- James H. Kabbler III" +
"|\"When his life was ruined, his family killed, his farm  destroyed, Job knelt down on the ground and yelled up to the  heavens, 'Why god? Why me?' and the thundering voice of God  answered, 'There's just something about you that pisses me  off.'\"<br> -- Stephen King" +
"|\"How can I believe in God when just last week I got my tongue  caught in the roller of an electric typewriter?\"<br> -- Woody Allen" +
"|\"If there is no God, who pops up the next Kleenex?\"<br> -- Art Hoppe" +
"|\"My mother said to me, \"If you are a soldier, you will become a  general. If you are a monk, you will become the Pope.\" Instead, I was a painter, and became Picasso.\"<br> -- Pablo Picasso" +
"|\"I was thrown out of college for cheating on the metaphysics  exam; I looked into the soul of the boy next to me.\" <br> -- Woody Allen" +
"|\"A good sermon should be like a woman's skirt: short enough to  arouse interest but long enough to cover the essentials.\" <br> -- Ronald Knox" +
"|\"Not only is there no God, but you try getting a plumber at  weekends.\"<br> -- Woody Allen" +
"|\"As God once said, and I think rightly...\"<br> -- Margaret Thatcher" +
"|\"Hearing nuns' confessions is like being stoned to death with  popcorn.\"<br> -- Fulton Sheen" +
"|\"If there is no Hell, a good many preachers are obtaining money  under false pretences.\"<br> -- William Sunday" +
"|\"I admire the Pope. I have a lot of respect for anyone who can  tour without an album.\"<br> -- Rita Rudner" +
"|\"Thank God I'm an atheist.\"<br> -- Luis Bunuel" +
"|\"The Bible was a consolation to a fellow alone in the old cell.  The lovely thin paper with a bit of matress stuffing in it, if  you could get a match, was as good a smoke as I ever tasted.\" <br> -- Brendan Behan" +
"|\"In the begining there was nothing and God said 'Let there be  light', and there was still nothing but everybody could see it.\" <br> -- Dave Thomas" +
"|\"Sailors ought never to go to church. They ought to go to hell,  where it is much more comfortable.\"<br> -- HG Wells" +
"|\"If absolute power corrupts absolutely, where does that leave  God?\"<br> -- George Deacon" +
"|\"I don't believe in the after life, although I am bringing a change of underwear.\"<br> -- Woody Allen" +
"|\"When I was a kid I used to pray every night for a new bicycle.  Then I realised that the Lord doesn't work that way so I stole  one and asked Him to forgive me.\"<br> -- Emo Philips" +
"|\"When I told the people of Northern Ireland that I was an  atheist, a woman in the audience stood up and said, 'Yes, but  is it the God of the Catholics or the God of the Protestants  in whom you don't believe?\"<br> -- Quentin Crisp" +
"|\"When I am dead, I hope it may be said: 'His sins were scarlet  but his books were read.\"<br> -- Hillaire Belloc" +
"|\"Sometimes I lie awake at night, and I ask, 'Where have I gone  wrong?' Then a voice says to me, 'This is going to take more  than one night.'\"<br> -- Charlie Brown" +
"|\"Maybe there is no actual place called hell. Maybe hell is just  having to listen to our grandparents breathe through their noses when they're eating sandwiches.\"<br> -- Jim Carrey" +
"|\"Build a man a fire, and he'll be warm for a day. Set a man on  fire, and he'll be warm for the rest of his life.\" <br> -- Terry Pratchett" +
"|\"When did I realize I was God? Well, I was praying and I suddenly realized I was talking to myself.\"<br> -- Peter O'Toole" +
"|\"They say such nice things about people at their funerals that it makes me sad that I'm going to miss mine by just a few days.\" <br> -- Garrison Kielor" +
"|\"It was God who made me so beautiful. If I weren't, then I'd be a teacher.\"<br> -- Linda Evangelista" +
"|\"The secret of a good sermon is to have a good beginning and a  good ending, then having the two as close together as possible.\"<br> -- George Burns" +
"|\"I would have made a good Pope.\"<br> -- Richard Nixon" +
"|\"I was raised in the Jewish tradition, taught never to marry a Gentile woman, shave on a Saturday night and, most especially,  never to shave a Gentile woman on a Saturday night.\" <br> -- Woody Allen" +
"|\"God is love, but get it in writing.\"<br> -- Gypsy Rose Lee" +
"|\"I don't pray because I don't want to bore God.\"<br> -- Orson Welles" +
"|\"As the post said, 'Only God can make a tree,' probably because  it's so hard to figure out how to get the bark on.\" <br> -- Woody Allen" +
"|\"I have four children which is not bad considering I'm not a Catholic.\"<br> -- Peter Ustinov" +
"|\"I hear Glenn Hoddle has found God. That must have been one hell of a pass.\"<br> -- Bob Davies" +
"|\"And God said, 'Let there be light' and there was light, but the Electricity Board said He would have to wait until Thursday to be connected.\"<br> -- Spike Milligan" +
"|\"No mention of God. They keep Him up their sleeves for as long as they can, vicars do. They know it puts people off.\" <br> -- Alan Bennett" +
"|\"I'm Jewish. I don't work out. If God had wanted us to bend over,  He would have put diamonds on the floor.\"<br> -- Joan Rivers" +
"|\"There is a charm about the forbidden that makes it unspeakably diserable.\"<br> -- Mark Twain" +
"|\"Always go to other people's funerals, otherwise they won't come  to yours.\"<br> -- Yogi Berra" +
"|\"Death is a low chemical trick played on everybody except sequoia trees.\"<br> -- JJ Furnas" +
"|\"Dying is a very dull, dreary affair. And my advice to you is to have nothing whatever to do with it.\"<br> -- W. Somerset Maugham" +
"|\"Early to rise and early to bed. Makes a male healthy, wealthy  and dead.\"<br> -- James Thurber" +
"|\"Everybody wants to go to heaven, but nobody wants to die.\"<br> -- Joe Louis" +
"|\"He had decided to live forever or die in the attempt.\"<br> -- Joseph Heller" +
"|\"I am ready to meet my Maker. Whether my Maker is prepared for  the great ordeal of meeting me is another matter.\" <br> -- Winston Churchill" +
"|\"Death is one of the few things that can be done as easily lying  down. The difference between sex and death is that with death  you can do it alone and no one is going to make fun of you.\" <br> -- Woody Allen" +
"|\"All our knowledge merely helps us to die a more painful death  than animals that know nothing.\"<br> -- Maurice Maeterlinck" +
"|\"A single death is a tragedy, a million deaths is a statistic.\"<br> -- Joseph Stalin" +
"|\"Eternal nothingness is fine if you happen to be dressed for it.\"<br> -- Woody Allen" +
"|\"Everything is drive-through. In California, they even have a  burial service called Jump-In-The-Box.\"<br> -- Wil Shriner" +
"|\"In this world, nothing is certain but death and taxes.\"<br> -- Benjamin Franklin" +
"|\"The fear of death is the most unjustified of all fears, for  there's no risk of accident for someone who's dead.\" <br> -- Albert Einstein" +
"|\"I wouldn't mind dying - it's the business of having to stay  dead that scares the shit out of me.\"<br> -- R. Geis" +
"|\"It's impossible to experience one's death objectively and still  carry a tune.\"<br> -- Woody Allen" +
"|\"For if he like a madman lived, At least he like a wise one died.\"<br> -- Cervantes" +
"|\"Death does not concern us, because as long as we exist, death is  not here. And when it does come, we no longer exist.\" <br> -- Epicurus" +
"|\"Am I lightheaded because I'm not dead or because I'm still  alive?\"<br> -- Heidi Sandige" +
"|\"A low voter turnout is an indication of fewer people going to  the polls.\"<br> -- George W. Bush" +
"|\"I was raised in the West. The west of Texas. It's pretty close  to California. In more ways than Washington, D.C., is close to California.\"<br> -- George W. Bush" +
"|\"Rarely is the question asked: Is our children learning?\"<br> -- George W. Bush" +
"|\"What I am against is quotas. I am against hard quotas, quotas  they basically delineate based upon whatever. However they  delineate, quotas, I think, vulcanize society. So I don't know  how that fits into what everybody else is saying, their relative  positions, but that's my position.\"<br> -- George W. Bush" +
"|\"It's clearly a budget. It's got a lot of numbers in it.\"<br> -- George W. Bush" +
"|\"One word sums up probably the responsibility of any Governor,  and that one word is 'to be prepared'.\"<br> -- George W. Bush" +
"|\"If you're sick and tired of the politics of cynicism and polls  and principles, come and join this campaign.\"<br> -- George W. Bush" +
"|\"We must all hear the universal call to like your neighbor like  you like to be liked yourself.\"<br> -- George W. Bush" +
"|\"The most important job is not to be Governor, or First Lady in  my case.\"<br> -- George W. Bush" +
"|\"If people can judge me on the company I keep, they would judge  me with keeping really good company with Laura.\" <br> -- George W. Bush" +
"|\"You'll notice that Nancy Reagan never drinks water when Ronnie speaks.\"<br> -- Robin Williams" +
"|\"I'm not going to have some reporters pawing through our papers.  We are the president.\"<br> -- Hillary Clinton" +
"|\"A committee is a group of people who individually can do nothing but together can decide that nothing can be done.\"<br> -- Fred Allen" +
"|\"Richard Nixon is a no good, lying bastard. He can lie out of  both sides of his mouth at the same time, and if he ever caught  himself telling the truth, he'd lie just to keep his hand in.\"<br> -- Harry S. Truman" +
"|\"Behind every successful man is a woman, behind her is his wife.\"<br> -- Groucho Marx" +
"|\"Marry me and I'll never look at another horse!\"<br> -- Groucho Marx" +
"|\"A woman is an occasional pleasure but a cigar is always a smoke.\"<br> -- Groucho Marx" +
"|\"Outside of a dog, a book is man's best friend. Inside of a dog,  it's too dark to read.\"<br> -- Groucho Marx" +
"|\"Why was I with her? She reminds me of you. In fact, she reminds  me more of you than you do!\"<br> -- Groucho Marx" +
"|\"Women should be obscene and not heard.\"<br> -- Groucho Marx" +
"|\"Either he's dead or my watch has stopped.\"<br> -- Groucho Marx" +
"|\"I don't care to belong to a club that accepts people like me as members.\"<br> -- Groucho Marx" +
"|\"I must confess, I was born at a very early age.\"<br> -- Groucho Marx" +
"|\"I have had a perfectly wonderful evening, but this wasn't it.\"<br> -- Groucho Marx" +
"|\"Room service? Send up a larger room.\"<br> -- Groucho Marx" +
"|\"I never forget a face, but in your case I'll be glad to make an  exception.\"<br> -- Groucho Marx" +
"|\"A man's only as old as the woman he feels.\"<br> -- Groucho Marx" +
"|\"One morning I shot a bear in my pajamas. How it got into my pajamas I'll never know.\"<br> -- Groucho Marx" +
"|\"If I held you any closer I would be on the other side of you.\"<br> -- Groucho Marx" +
"|\"I was married by a judge. I should have asked for a jury.\"<br> -- Groucho Marx" +
"|\"Who are you going to believe, me or your own eyes?\"<br> -- Groucho Marx" +
"|\"Quote me as saying I was mis-quoted.\"<br> -- Groucho Marx" +
"|\"A child of five could understand this. Fetch me a child of five.\"<br> -- Groucho Marx" +
"|\"Those are my principles. If you don't like them I have others.\"<br> -- Groucho Marx" +
"|\"Police arrested two kids yesterday, one was drinking battery  acid, the other was eating fireworks. They charged one and let  the other one off.\"<br> -- Tommy Cooper" +
"|\"A blind bloke walks into a shop with a guide dog. He picks the  Dog up and starts swinging it around his head. Alarmed, a shop  assistant calls out: 'Can I help, sir?' 'No thanks,' says the  blind bloke. 'Just looking.'\" <br> -- Tommy Cooper" +
"|\"It's strange, isn't it. You stand in the middle of a library  and go 'aaaaagghhhh' and everyone just stares at you. But you  do the same thing on an aeroplane, and everyone joins in.\" <br> -- Tommy Cooper" +
"|\"So I was getting into my car, and this bloke says to me \"Can you give me a lift?\" I said \"Sure, you look great, the world's your oyster, go for it.'\"<br> -- Tommy Cooper" +
"|\"You know, somebody actually complimented me on my driving today. They left a little note on the windscreen, it said 'Parking Fine.'\"<br> -- Tommy Cooper" +
"|\"So I went to the dentist. He said \"Say Aaah.\" I said \"Why?\" He said \"My dog's died.'\"<br> -- Tommy Cooper" +
"|\"So I rang up a local building firm, I said 'I want a skip outside my house.' He said 'I'm not stopping you.'\"<br> -- Tommy Cooper" +
"|\"So I was in my car, and I was driving along, and my boss rang up and he said 'You've been promoted'. And I swerved. And then he rang up a second time and said 'You've been promoted again'. And I swerved again. He rang up a third time and said 'You're managing director.'  And I went into a tree. And a policeman came up and said 'What happened to you?' And I Said 'I careered off the road.'\"<br> -- Tommy Cooper" +
"|\"Don't knock masturbation, it's sex with someone I love .\"<br> -- Woody Allen, From 'Annie Hall' 1977" +
"|\"A fast word about oral contraception. I asked a girl to go to  bed with me, she said 'no'.\"<br> -- Woody Allen" +
"|\"It's not that I'm afraid to die, I just don't want to be there when it happens.\"<br> -- Woody Allen, From 'Death' 1975" +
"|\"There are worse things in life than death. Have you ever spent an evening with an insurance salesman?\"<br> -- Woody Allen" +
"|\"Money is better than poverty, if only for financial reasons.\"<br> -- Woody Allen, From 'Without Feathers' 1976" +
"|\"I failed to make the chess team because of my height.\" <br> -- Woody Allen" +
"|\"I believe that sex is a beautiful thing between two people.  Between five, it's fantastic.\"<br> -- Woody Allen" +
"|\"Love is the answer - but while you're waiting for the answer sex raises some pretty good questions.\"<br> -- Woody Allen" +
"|\"I'm very proud of my gold pocket watch. My grandfather, on his deathbed, sold me this watch.\"<br> -- Woody Allen" +
"|\"I'm always amazed to hear of air crash victims so badly  mutilated that they have to be identified by their dental  records. What I can't understand is, if they don't know who you  are, how do they know who your dentist is?\"<br> -- Paul Merton" +
"|\"The Stones, I love the Stones. I watch them whenever I can. Fred, Barney...\"<br> -- Steven Wright" +
"|\"First you forget names, then you forget faces. Next you forget to pull your zipper up and finally, you forget to pull it down.\"<br> -- George Burns" +
"|\"The pen is mightier than the sword, and considerably easier to write with.\"<br> -- Marty Feldman" +
"|\"We had gay burglars the other night. They broke in and rearranged the furniture.\"<br> -- Robin Williams" +
"|\"If toast always lands butter-side down, and cats always land on their feet, what happens if you strap toast on the back of a cat and drop it?\"<br> -- Steven Wright" +
"|\"I'm desperately trying to figure out why kamikaze pilots wore helmets.\"<br> -- Dave Edison" +
"|\"Did you ever walk in a room and forget why you walked in? I think that's how dogs spend their lives.\"<br> -- Sue Murphy" +
"|\"A sure cure for seasickness is to sit under a tree.\" <br> -- Spike Milligan" +
"|\"Why don't they make the whole plane out of that black box stuff.\"<br> -- Steven Wright" +
"|\"I once heard two ladies going on and on about the pains of  childbirth and how men don't seem to know what real pain is. I  asked if either of them ever got themselves caught in a zipper.\" <br> -- Emo Philips" +
"|\"My neighbour asked if he could use my lawnmower and I told him of course he could, so long as he didn't take it out of my garden.\"<br> -- Eric Morecambe" +
"|\"You're about as useful as a one-legged man at an arse kicking contest.\"<br> -- Rowan Atkinson" +
"|\"He managed to stupid himself right into the White House.\"<br> -- Charles Appel about George W. Bush" +
"|\"Reality is that which, when you stop believing in it, doesn't go away.\"<br> -- Philip K. Dick" +
"|\"Believe those who are seeking the truth. Doubt those who find  it.\"<br> -- André Gide" +
"|\"Just because bulldozers are used to build highways doesn't mean bulldozers are the best way to travel on a highway.\"<br> -- Danny Thorpe in borland.public.delphi.non-technical" +
"|\"Write a wise word and your name will live forever.\"<br> -- Anonymous" +
"|\"To the Honourable Member opposite I say, when he goes home  tonight, may his mother run out from under the porch and bark at  him\"<br> -- John G. Diefenbaker" +
"|\"Sterling's Corollary to Clarke's Law: Any sufficiently advanced garbage is indistinguishable from magic.\"" +
"|\"Minsky's Second Law: Don't just do something. Stand there.\"-- Marvin Minsky" +
"|\"Devlin's First Law - Buyer beware: in the hands of a charlatan,  mathematics can be used to make a vacuous argument look  impressive. Devlin's Second Law - So can PowerPoint.\"<br> -- Keith Devlin" +
"|\"Gigerenzer's Law of Indispensable Ignorance: The world cannot  function without partially ignorant people.\"<br> -- Gerd Gigerenzer" +
"|\"Lohr's Law: The future is merely the past with a twist — and  better tools.\"<br> -- Steve Lohr" +
"|\"Raymond's Law of Software: Given a sufficiently large number of  eyeballs, all bugs are shallow.\"<br> -- Eric S. Raymond" +
"|\"Barabási's Law of Programming: Program development ends when the  program does what you expect it to do — whether it is correct or not.\"<br> -- Albert-László Barabási" +
"|\"Anyone who starts a sentence, 'With all due respect ...' is about to insult you.\"<br> -- unknown" +
"|\"The only one listening to both sides of an argument is the neighbor in the next apartment\"<br> -- unknown" +
"|\"Cholesterol is your natural defence against excessive  circulation of blood, which can carry venoms, poisons and other  toxins around your body.\"<br> -- Michael Warner, in bpot" +
"|\"Mit der Dummheit kämpfen Götter selbst vergebens\"|\"Against stupidity the (very) gods themselves contend in vain\"<br> -- Friedrich von Schiller" +
"|\"There Ought to be Limits to Freedom!\" <br> -- George W. Bush, commenting on gwbush.com (05/21/1999)" +
"|\"We are Dyslexia of Borg. Fusistance is retile. Your ass will be laminated.\"<br> -- unknown" +
"|ICTOARTCYAODHTIOTSSIWRTNCAHICGAWI, Acronym: \"I Can't Think Of  Anything Reasonable To Counter Your Argument Or Don't Have The  Least Inkling Of The Subject So I Will Resort To Name Calling  And Hope I Can Get Away With It.\" <br> -- Ken de Camargo, borland.public.off-topic" +
"|\"I don't approve of political jokes... I've seen too many of them get elected.\"<br> -- unknown" +
"|\"I plan to live forever. So far so good.\"  <br> -- Rob C. Claffie in borland.public.off-topic" +
"|\"Millions long for immortality who do not know what to do with themselves on a rainy Sunday afternoon.\"<br> -- Susan Ertz" +
"|\"If the United Nations once admits that international disputes  can be settled by using force, then we will have destroyed the  foundation of the organization and our best hope of establishing  a world order.\"<br> -- Dwight D. Eisenhower " +
"|\"When you hear hoofbeats, think of horses, not zebras.\"-- Old saying" +
"|\"Sex is like a Chinese dinner. It isn't over until everyone gets their cookies.\"<br> -- from the movie \"Outside Providence\"" +
"|\"A picture is worth a thousand words (which is why it takes a  thousand times longer to load...)\" <br> -- Eric Tilton, Composing Good HTML" +
"|\"1001 words say more than one picture\"<br> -- Chinese proverb" +
"|\"There is no idea so simple and powerful that you can't get  zillions of people to misunderstand it.\"<br> -- Alan Kay" +
"|\"The purpose of computing is not numbers but insight.\" <br> -- Richard Hamming" +
"|\"They have computers, and they may have other weapons of mass destruction.\"<br> -- Janet Reno, Us Attorney General, 02-27-98" +
"|\"Absence of evidence is not evidence of absence.\"-- Source Unknown" +
"|\"Imagine if every Thursday your shoes exploded if you tied them the usual way. This happens to us all the time with computers, and nobody thinks of complaining.\"<br> -- Jeff Raskin" +
"|\"Programming is like sex: one mistake and you have to support it  for the rest of your life.\"<br> -- Michael Sinz" +
"|\"Linux is like living in a teepee. No Windows, no Gates, Apache  in house.\"<br> -- Usenet signature" +
"|\"DOS Computers manufactured by companies such as IBM, Compaq,  Tandy, and millions of others are by far the most popular, with  about 70 million machines in use worldwide. Macintosh fans, on  the other hand, may note that cockroaches are far more numerous  than humans, and that numbers alone do not denote a higher life  form.\"<br> -- New York Times, November 26, 1991" +
"|\"Politics is the art of looking for trouble, finding it  everywhere, diagnosing it incorrectly, and applying the wrong  remedies.\"<br> -- Groucho Marx" +
"|\"Momma always said life was like a box of chocolates. You never know what you're gonna get.\"<br> -- Forest Gump " +
"|\"I invented the term Object-Oriented, and I can tell you I did  not have C++ in mind.\"<br> -- Alan Kay" +
"|\"Reality is merely an illusion, albeit a very persistent one.\"  <br> -- Albert Einstein " +
"|\"Never test for an error condition you don't know how to handle.\" -- Steinbach's Guideline for Systems Programmers. " +
"|\"Science is what people understand well enough to explain to a  computer. All else is art.\"<br> -- Donald Knuth" +
"|\"Beware of bugs in the above code; I have only proven it correct, not tried it.\" -- Donald E. Knuth.  " +
"|\"Object-oriented programming is an exceptionally bad idea which could only have originated in California.\"<br> -- Edsger Dijkstra" +
"|\"Object-oriented programming is a style of programming designed  to teach students about stacks.\"<br> -- Edsger Dijkstra" +
"|\"Programming is one of the most difficult branches of applied mathematics; the poorer mathematicians had better remain pure mathematicians.\"<br> -- Edsger Dijkstra" +
"|\"The use of anthropomorphic terminology when dealing with  computing systems is a symptom of professional immaturity.\"<br> -- Edsger Dijkstra" +
"|\"About the use of language: it is impossible to sharpen a pencil  with a blunt axe. It is equally vain to try to do it with ten  blunt axes instead.\"<br> -- Edsger W. Dijkstra" +
"|\"If FORTRAN has been called an infantile disorder, then PL/I must  be classified as a fatal disease.\"<br> -- Edsger Dijkstra" +
"|\"Testing proves the presence, not the absence, of bugs.\"<br> -- Edsger Dijkstra" +
"|\"The question of whether a computer can think is no more  interesting than the question of whether a submarine can swim.\" <br> -- Edsger Dijkstra " +
"|\"It is practically imposible to teach good programming to  students that have had a prior exposure to BASIC: as potential  programmers they are mentally mutilated beyond hope of  regeneration.\"<br> -- Edsger Dijkstra" +
"|\"The use of COBOL cripples the mind; its teaching should,  therefore, be regarded as a criminal offense.\" <br> -- Edsger Dijkstra " +
"|Bible, Dijkstra 5:15\"and the clueless shall spend their time reinventing the wheel  while the elite merely use the Wordstar key mappings\" <br> -- Ed Mulroy" +
"|\"Why did God create dentists?<br> -- In his infinite love, he  thought it would be charitable to His creatures to let them  see what Hell is like, during their lives.\"<br> -- PhR" +
"|Customer: \"I'm running Windows '95.\"Tech:     \"Yes.\"Customer: \"My computer isn't working now.\"Tech:     \"Yes, you said that.\"" +
"|\"If we knew what it was we were doing, it would not be called  research, would it?\"<br> -- Albert Einstein" +
"|\"A [pseudo]random number generator is much like sex: when it's  good it's wonderful, and when it's bad it's still pretty good.\" <br> -- G. Marsaglia " +
"|\"A model is done when nothing else can be taken out.\"<br> -- Dyson " +
"|\"Real life is that big, high-res, high-color screen saver behind all the windows.\"<br> -- anonymous" +
"|\"We've all heard that a million monkeys banging on a million typewriters will eventually reproduce the entire works of  Shakespeare. Now, thanks to the Internet, we know this is not  true.\"<br> -- Robert Wilensky " +
"|\"Not everything that can be counted counts, and not everything  that counts can be counted.\"<br> -- Albert Einstein " +
"|\"Physics is not a religion. If it were, we'd have a much easier  time raising money.\"<br> -- Leon Lenderman " +
"|\"Java, the best argument for Smalltalk since C++.\"<br> -- unknown" +
"|\"Computers are useless; they can only give you answers.\" <br> -- Pablo Picasso " +
"|\"Life would be so much easier if we could just see the source  code.\"<br> -- unknown" +
"|\"Deliver yesterday, code today, think tomorrow.\"<br> -- unknown" +
"|\"Having the source code is the difference between buying a house  and renting an apartment.\"<br> -- Behlendorf" +
"|\"C++: an octopus made by nailing extra legs onto a dog\" <br> -- unknown " +
"|\"C combines all the power of assembly language with the ease of  use of assembly language\"<br> -- trad" +
"|\"God is real unless declared integer\"<br> -- david " +
"|\"Java: the elegant simplicity of C++ and the blazing speed of Smalltalk.\"<br> -- Roland Turner" +
"|\"Quotation confesses inferiority.\"<br> -- Ralph Waldo Emerson " +
"|\"A mind all logic is like a knife all blade. It makes the hand  bleed that uses it.\"<br> -- Rabindranath Tagore" +
"|\"Sometimes, the best answer is a more interesting question\"<br> -- Terry Pratchett " +
"|\"Before C++ we had to code all of our bugs by hand; now we  inherit them.\"<br> -- unknown " +
"|\"Incrementing C by 1 is not enough to make a good object-oriented language.\" <br> -- M. Sakkinen" +
"|\"Science is like sex: sometimes something useful comes out, but  that is not the reason we are doing it\"<br> -- Richard Feynman  " +
"|\"Man is the best computer we can put aboard a spacecraft... and  the only one that can be mass produced with unskilled labor.\"<br> -- Wernher von Braun " +
"|\"Computer /nm./: a device designed to speed and automate errors.\" -- From the Jargon File. " +
"|\"RAM /abr./: Rarely Adequate Memory.\"<br> -- From the Jargon File" +
"|\"A printer consists of three main parts: the case, the jammed  paper tray and the blinking red light\"<br> -- unknown" +
"|\"Real Programmers always confuse Christmas and Halloween because Oct31 == Dec25 !\" -- Andrew Rutherford " +
"|\"2 + 2 = 5, for extremely large values of 2.\"<br> -- unknown" +
"|\"ASCII stupid question, get a stupid ANSI !\"<br> -- unknown" +
"|\"Multitasking /adj./ 3 PCs and a chair with wheels !\"<br> -- unknown" +
"|\"Pascal /n./ A programming language named after a man who would  turn over in his grave if he knew about it.\" <br> -- From the Jargon File" +
"|\"If it wasn't for C, we'd be writing programs in BASI, PASAL, and OBOL.\"<br> -- unknown" +
"|\"I have yet to meet a C compiler that is more friendly and easier  to use than eating soup with a knife.\"<br> -- unknown" +
"|\"... one of the main causes of the fall of the Roman Empire was  that, lacking zero, they had no way to indicate successful  termination of their C programs.\" -- Robert Firth" +
"|\"Do you program in Assembly ?\" she asked. \"NOP,\" he said" +
"|\"Smith & Wesson — the original point and click interface.\"" +
"|\"We should leave our minds open, but not so open that our brains  fall out.\"<br> -- Alan Ross Anderson" +
"|\"The difference between what the most and the least learned  people know is inexpressibly trivial in relation to that which  is unknown.\" <br> -- Albert Einstein" +
"|\"Statistics is like a bikini. What they reveal is suggestive. What they conceal is vital.\"<br> -- Arthur Koestler" +
"|\"A hen is only an egg’s way of making another egg.\" <br> -- Samuel Butler" +
"|\"It is a miracle that curiosity survives formal education.\" <br> -- Albert Einstein" +
"|\"Gravity cannot be held responsible for people falling in love.\" <br> -- Albert Einstein" +
"|\"Common sense is the collection of prejudices acquired by age  eighteen.\"<br> -- Albert Einstein" +
"|\"The secret to creativity is knowing how to hide your sources.\" <br> -- Albert Einstein" +
"|\"Intellectuals solve problems; geniuses prevent them.\" <br> -- Albert Einstein" +
"|\"Put your hand on a hot stove for a minute, and it seems like an  hour. Sit with a pretty girl for an hour, and it seems like a  minute. THAT'S relativity.\"<br> -- Albert Einstein?" +
"|\"To iterate is human, to recurse divine.\"<br> -- L. Peter Deutsch" +
"|\"Premature optimization is the root of all evil.\"<br> -- Donald Knuth" +
"|\"UNIX is simple. It just takes a genius to understand its  simplicity.\"-- Dennis Ritchie" +
"|\"If you give a man a fish, he will eat for today. If you teach  him to fish, he'll understand why some people think golf is  exciting.\"<br> -- P.G. Wodehouse" +
"|\"I'd give my right arm to be ambidextrous.\"<br> -- Brian Kernighan" +
"|\"I know that there are people in this world who do not love  their fellow human beings, and I hate people like that.\" <br> -- Tom Lehrer" +
"|\"Yes, I'm fat, but you're ugly and I can go on a diet.\" <br> -- bumper sticker" +
"|\"I want to die in my sleep like my grandfather...  not screaming and yelling like the passengers in his car...\" <br> -- bumper sticker" +
"|\"Time is the best teacher; Unfortunately it kills all its  students!\"<br> -- bumper sticker" +
"|\"Diplomacy is the art of saying 'Nice doggie!'... 'til you can  find a rock.\"<br> -- bumper sticker                             " +
"|\"Ever stop to think, and forget to start again?\" <br> -- bumper sticker" +
"|\"If you need more than five lines to prove something, then you  are on the wrong track\" <br> -- Edgser W. Dijkstra's mother [ibid, p. 55]" +
"|\"If you think it's simple, then you have misunderstood the  problem.\"<br> -- Bjarne Stroustrup [lecture at Temple U., 11/25/97]" +
"|\"True. When your hammer is C++, everything begins to look like a thumb.\"<br> -- Steve Haflich, in comp.lang.c++ " +
"|\"I have made this letter longer than usual because I lack the time to make it shorter.\"<br> -- Blaise Pascal" +
"|The \"abort()\" function is now called \"choice().\"-- from the \"Politically Correct UNIX System VI Release notes\"" +
"|\"We don't make mistakes, we just have happy little accidents.\"-- Bob Ross, \"The Joy of Painting\" " +
"|\"Modern capitalism is not about free markets, it is about  building sufficient mass that the market gravitationally  collapses around you.\"-- Alisdair Meredith" +
"|\"If quantum physics doesn't confuse you then you don't  understand it.\"<br> -- Niels Bohr  " +
"|\"If the brain were so simple we could understand it, we would  be so simple we couldn't.\"<br> -- Lyall Watson" +
"|\"Moral indignation is jealousy with a halo.\"-- H. G. Wells (1866-1946)" +
"|\"Glory is fleeting, but obscurity is forever.\"-- Napoleon Bonaparte (1769-1821)" +
"|\"Victory goes to the player who makes the next-to-last mistake.\"-- Chessmaster Savielly Grigorievitch Tartakower (1887-1956)" +
"|\"Don't be so humble - you are not that great.\"-- Golda Meir (1898-1978) to a visiting diplomat" +
"|\"His ignorance is encyclopedic\"-- Abba Eban (1915-2002)" +
"|\"If a man does his best, what else is there?\"-- General George S. Patton (1885-1945)" +
"|\"I can write better than anybody who can write faster, and I can  write faster than anybody who can write better.\"<br> -- A. J. Liebling (1904-1963)" +
"|\"People demand freedom of speech to make up for the freedom of  thought which they avoid.\"<br> -- Soren Aabye Kierkegaard (1813-1855)" +
"|\"Give me chastity and continence, but not yet.\"<br> -- Saint Augustine (354-430)" +
"|\"Not everything that can be counted counts, and not everything  that counts can be counted.\"<br> -- Albert Einstein (1879-1955)" +
"|\"Only two things are infinite, the universe and human stupidity,  and I'm not sure about the former.\"<br> -- Albert Einstein (1879-1955)" +
"|\"A lie gets halfway around the world before the truth has a  chance to get its pants on.\"<br> -- Sir Winston Churchill (1874-1965)" +
"|\"I do not feel obliged to believe that the same God who has  endowed us with sense, reason, and intellect has intended us  to forgo their use.\"<br> -- Galileo Galilei" +
"|\"The artist is nothing without the gift, but the gift is nothing  without work.\"<br> -- Emile Zola (1840-1902)" +
"|\"This book fills a much-needed gap.\"-- Moses Hadas (1900-1966) in a review" +
"|\"The full use of your powers along lines of excellence.\"-- definition of \"happiness\" by John F. Kennedy (1917-1963)" +
"|\"I'm living so far beyond my income that we may almost be said  to be living apart.\"<br> -- e e cummings (1894-1962)" +
"|\"Give me a museum and I'll fill it.\"-- Pablo Picasso (1881-1973)" +
"|\"Assassins!\"-- Arturo Toscanini (1867-1957) to his orchestra" +
"|\"I'll moider da bum.\"<br> -- Heavyweight boxer Tony Galento, when asked what he thought of     William Shakespeare" +
"|\"In theory, there is no difference between theory and practice.  But, in practice, there is.\"<br> -- Jan L.A. van de Snepscheut" +
"|\"I find that the harder I work, the more luck I seem to have.\"<br> -- Thomas Jefferson (1743-1826)" +
"|\"Each problem that I solved became a rule which served afterwards  to solve other problems.\"<br> -- Rene Descartes (1596-1650), \"Discours de la Methode\"" +
"|\"In the End, we will remember not the words of our enemies, but  the silence of our friends.\"<br> -- Martin Luther King Jr. (1929-1968)" +
"|\"Whether you think that you can, or that you can't, you are  usually right.\"<br> -- Henry Ford (1863-1947)" +
"|\"Do, or do not. There is no 'try'.\"<br> -- Yoda ('The Empire Strikes Back')" +
"|\"The only way to get rid of a temptation is to yield to it.\"<br> -- Oscar Wilde (1854-1900)" +
"|\"Don't stay in bed, unless you can make money in bed.\"<br> -- George Burns (1896-1996)" +
"|\"I don't know why we are here, but I'm pretty sure that it is  not in order to enjoy ourselves.\"<br> -- Ludwig Wittgenstein (1889-1951)" +
"|\"The use of COBOL cripples the mind; its teaching should,  therefore, be regarded as a criminal offense.\"<br> -- Edsger Dijkstra" +
"|\"C makes it easy to shoot yourself in the foot; C++ makes it  harder, but when you do, it blows away your whole leg.\"<br> -- Bjarne Stroustrup" +
"|\"A mathematician is a device for turning coffee into theorems.\"<br> -- Paul Erdos" +
"|\"The only difference between me and a madman is that I'm not mad.\"<br> -- Salvador Dali (1904-1989)" +
"|\"If you can't get rid of the skeleton in your closet, you'd best  teach it to dance.\"<br> -- George Bernard Shaw (1856-1950)" +
"|\"But at my back I always hear Time's winged chariot hurrying  near.\"<br> -- Andrew Marvell (1621-1678)" +
"|\"Good people do not need laws to tell them to act responsibly,  while bad people will find a way around the laws.\"<br> -- Plato (427-347 B.C.)" +
"|\"The power of accurate observation is frequently called cynicism  by those who don't have it.\"<br> -- George Bernard Shaw (1856-1950)" +
"|\"Whenever I climb I am followed by a dog called 'Ego'.\"    - Friedrich Nietzsche (1844-1900)" +
"|\"We have art to save ourselves from the truth.\"    - Friedrich Nietzsche (1844-1900)" +
"|\"Never interrupt your enemy when he is making a mistake.\"    - Napoleon Bonaparte (1769-1821)" +
"|\"I think 'Hail to the Chief' has a nice ring to it.\"<br> -- John F. Kennedy (1917-1963) when asked what is his favorite     song" +
"|\"Human history becomes more and more a race between education  and catastrophe.\"<br> -- H. G. Wells (1866-1946)" +
"|\"Talent does what it can; genius does what it must.\"    - Edward George Bulwer-Lytton (1803-1873)" +
"|\"The difference between 'involvement' and 'commitment' is like an  eggs-and-ham breakfast: the chicken was 'involved' - the pig was  'committed'.\"<br> -- unknown" +
"|\"If you are going through hell, keep going.\"    - Sir Winston Churchill (1874-1965)" +
"|\"I'm all in favor of keeping dangerous weapons out of the hands  of fools. Let's start with typewriters.\"-- Frank Lloyd Wright (1868-1959)" +
"|\"Some cause happiness wherever they go; others, whenever they go.\"<br> -- Oscar Wilde (1854-1900)" +
"|\"God is a comedian playing to an audience too afraid to laugh.\"<br> -- Voltaire (1694-1778)" +
"|\"He is one of those people who would be enormously improved by  death.\"<br> -- H. H. Munro (Saki) (1870-1916)" +
"|\"I am ready to meet my Maker. Whether my Maker is prepared for  the great ordeal of meeting me is another matter.\"<br> -- Sir Winston Churchill (1874-1965)" +
"|\"I shall not waste my days in trying to prolong them.\"<br> -- Ian L. Fleming (1908-1964)" +
"|\"If you can count your money, you don't have a billion dollars.\"<br> -- J. Paul Getty (1892-1976)" +
"|\"Facts are the enemy of truth.\"<br> -- Don Quixote - \"Man of La Mancha\"" +
"|\"When you do the common things in life in an uncommon way, you  will command the attention of the world.\"<br> -- George Washington Carver (1864-1943)" +
"|\"How wrong it is for a woman to expect the man to build the world  she wants, rather than to create it herself.\"<br> -- Anais Nin (1903-1977)" +
"|\"I have not failed. I've just found 10,000 ways that won't work.\"<br> -- Thomas Alva Edison (1847-1931)" +
"|\"I begin by taking. I shall find scholars later to demonstrate  my perfect right.\"<br> -- Frederick (II) the Great" +
"|\"Maybe this world is another planet's Hell.\"<br> -- Aldous Huxley (1894-1963)" +
"|\"Blessed is the man, who having nothing to say, abstains from  giving wordy evidence of the fact.\"<br> -- George Eliot (1819-1880)" +
"|\"Once you eliminate the impossible, whatever remains, no matter  how improbable, must be the truth.\"<br> -- Sherlock Holmes (by Sir Arthur Conan Doyle, 1859-1930)" +
"|\"Black holes are where God divided by zero.\"    - Steven Wright" +
"|\"I've had a wonderful time, but this wasn't it.\"<br> -- Groucho Marx (1895-1977)" +
"|\"It's kind of fun to do the impossible.\"    - Walt Disney (1901-1966)" +
"|\"We didn't lose the game; we just ran out of time.\"    - Vince Lombardi" +
"|\"The optimist proclaims that we live in the best of all possible  worlds, and the pessimist fears this is true.\"<br> -- James Branch Cabell" +
"|\"A friendship founded on business is better than a business  founded on friendship.\"<br> -- John D. Rockefeller (1874-1960)" +
"|\"All are lunatics, but he who can analyze his delusion is called  a philosopher.\"<br> -- Ambrose Bierce (1842-1914)" +
"|\"You can only find truth with logic if you have already found  truth without it.\"<br> -- Gilbert Keith Chesterton (1874-1936)" +
"|\"An inconvenience is only an adventure wrongly considered; an  adventure is an inconvenience rightly considered.\"<br> -- Gilbert Keith Chesterton (1874-1936)" +
"|\"I have come to believe that the whole world is an enigma, a  harmless enigma that is made terrible by our own mad attempt to  interpret it as though it had an underlying truth.\"<br> -- Umberto Eco" +
"|\"Be nice to people on your way up because you meet them on your  way down.\"<br> -- Jimmy Durante" +
"|\"The true measure of a man is how he treats someone who can do  him absolutely no good.\"<br> -- Samuel Johnson (1709-1784)" +
"|\"A people that values its privileges above its principles soon  loses both.\"<br> -- Dwight D. Eisenhower (1890-1969), Inaugural Address,     January 20, 1953" +
"|\"The significant problems we face cannot be solved at the same  level of thinking we were at when we created them.\"<br> -- Albert Einstein (1879-1955)" +
"|\"Basically, I no longer work for anything but the sensation I  have while working.\"<br> -- Albert Giacometti (sculptor)" +
"|\"All truth passes through three stages. First, it is ridiculed.  Second, it is violently opposed. Third, it is accepted as being  self-evident.\"<br> -- Arthur Schopenhauer (1788-1860)" +
"|\"Many a man's reputation would not know his character if they  met on the street.\"<br> -- Elbert Hubbard (1856-1915)" +
"|\"There is more stupidity than hydrogen in the universe, and it  has a longer shelf life.\"<br> -- Frank Zappa" +
"|\"Perfection is achieved, not when there is nothing more to add,  but when there is nothing left to take away.\"<br> -- Antoine de Saint Exupéry" +
"|\"Life is pleasant. Death is peaceful. It's the transition that's  troublesome.\"<br> -- Isaac Asimov" +
"|\"If you want to make an apple pie from scratch, you must first  create the universe.\"<br> -- Carl Sagan" +
"|\"It is much more comfortable to be mad and know it, than to be  sane and have one's doubts.\"<br> -- G. B. Burgin" +
"|\"Once is happenstance. Twice is coincidence. Three times is  enemy action.\"<br> -- Auric Goldfinger, in \"Goldfinger\" by                    Ian L. Fleming (1908-1964)" +
"|\"To love oneself is the beginning of a lifelong romance\"<br> -- Oscar Wilde (1854-1900)" +
"|\"Knowledge speaks, but wisdom listens.\"<br> -- Jimi Hendrix" +
"|\"A clever man commits no minor blunders.\"<br> -- Goethe (1749-1832)" +
"|\"Argue for your limitations, and sure enough they're yours.\"<br> -- Richard Bach" +
"|\"A witty saying proves nothing.\"<br> -- Voltaire (1694-1778)" +
"|\"Education is a progressive discovery of our own ignorance.\"<br> -- Will Durant" +
"|\"I have often regretted my speech, never my silence.\"<br> -- Xenocrates (396-314 B.C.)" +
"|\"It was the experience of mystery<br> -- even if mixed with fear<br> --  that engendered religion.\"<br> -- Albert Einstein (1879-1955)" +
"|\"If everything seems under control, you're just not going fast  enough.\"<br> -- Mario Andretti" +
"|\"I do not consider it an insult, but rather a compliment to be  called an agnostic. I do not pretend to know where many ignorant  men are sure<br> -- that is all that agnosticism means.\"<br> -- Clarence Darrow, Scopes trial, 1925" +
"|\"Obstacles are those frightful things you see when you take your  eyes off your goal.\"<br> -- Henry Ford (1863-1947)" +
"|\"I'll sleep when I'm dead.\"<br> -- Warren Zevon" +
"|\"There are people in the world so hungry, that God cannot appear  to them except in the form of bread.\"<br> -- Mahatma Gandhi (1869-1948)" +
"|\"If you gaze long into an abyss, the abyss will gaze back into  you.\"<br> -- Friedrich Nietzsche (1844-1900)" +
"|\"The instinct of nearly all societies is to lock up anybody who  is truly free. First, society begins by trying to beat you up.  If this fails, they try to poison you. If this fails too, the  finish by loading honors on your head.\"<br> -- Jean Cocteau (1889-1963)" +
"|\"Everyone is a genius at least once a year; a real genius has his  original ideas closer together.\"<br> -- Georg Lichtenberg (1742-1799)" +
"|\"Success usually comes to those who are too busy to be looking  for it\"<br> -- Henry David Thoreau (1817-1862)" +
"|\"While we are postponing, life speeds by.\"<br> -- Seneca (3BC - 65AD)" +
"|\"Where are we going, and why am I in this handbasket?\"<br> -- Bumper Sticker" +
"|\"God, please save me from your followers!\"<br> -- Bumper Sticker" +
"|\"Fill what's empty, empty what's full, and scratch where it  itches.\"<br> -- the Duchess of Windsor, when asked what is the              secret of a long and happy life" +
"|\"First they ignore you, then they laugh at you, then they fight  you, then you win.\"<br> -- Mahatma Gandhi (1869-1948)" +
"|\"Luck is the residue of design.\"<br> -- Branch Rickey - former owner of the Brooklyn Dodger Baseball     Team" +
"|\"Tragedy is when I cut my finger. Comedy is when you walk into  an open sewer and die.\"<br> -- Mel Brooks" +
"|\"Most people would sooner die than think; in fact, they do so.\"<br> -- Bertrand Russell (1872-1970)" +
"|\"Wit is educated insolence.\"<br> -- Aristotle (384-322 B.C.)" +
"|\"My advice to you is get married: if you find a good wife you'll  be happy; if not, you'll become a philosopher.\"<br> -- Socrates (470-399 B.C.)" +
"|\"Egotist: a person more interested in himself than in me.\"<br> -- Ambrose Bierce (1842-1914)" +
"|\"A narcissist is someone better looking than you are.\"    - Gore Vidal" +
"|\"Wise men make proverbs, but fools repeat them.\"    - Samuel Palmer (1805-80)" +
"|\"It has become appallingly obvious that our technology has  exceeded our humanity.\"<br> -- Albert Einstein (1879-1955)" +
"|\"The secret of success is to know something nobody else knows.\"<br> -- Aristotle Onassis (1906-1975)" +
"|\"Sometimes when reading Goethe I have the paralyzing suspicion  that he is trying to be funny.\"<br> -- Guy Davenport" +
"|\"When you have to kill a man, it costs nothing to be polite.\"<br> -- Sir Winston Churchill (1874-1965)" +
"|\"Any man who is under 30, and is not a liberal, has not heart;  and any man who is over 30, and is not a conservative, has no  brains.\"<br> -- Sir Winston Churchill (1874-1965)" +
"|\"The opposite of a correct statement is a false statement. The  opposite of a profound truth may well be another profound truth.\"<br> -- Niels Bohr (1885-1962)" +
"|\"We all agree that your theory is crazy, but is it crazy enough?\"<br> -- Niels Bohr (1885-1962)" +
"|\"When I am working on a problem I never think about beauty. I  only think about how to solve the problem. But when I have  finished, if the solution is not beautiful, I know it is wrong.\"<br> -- Buckminster Fuller (1895-1983)" +
"|\"In science one tries to tell people, in such a way as to be  understood by everyone, something that no one ever knew before.  But in poetry, it's the exact opposite.\"<br> -- Paul Dirac (1902-1984)" +
"|\"I would have made a good Pope.\"<br> -- Richard M. Nixon (1913-1994)" +
"|\"In any contest between power and patience, bet on patience.\"<br> -- W.B. Prescott" +
"|\"Anyone who considers arithmetical methods of producing random  digits is, of course, in a state of sin.\"<br> -- John von Neumann (1903-1957)" +
"|\"The mistakes are all waiting to be made.\"<br> -- chessmaster Savielly Grigorievitch Tartakower (1887-1956)     on the game's opening position" +
"|\"It is unbecoming for young men to utter maxims.\"<br> -- Aristotle (384-322 B.C.)" +
"|\"Grove giveth and Gates taketh away.\"<br> -- Bob Metcalfe (inventor of Ethernet) on the trend of hardware    speedups not being able to keep up with software demands" +
"|\"Reality is merely an illusion, albeit a very persistent one.\"<br> -- Albert Einstein (1879-1955)" +
"|\"One of the symptoms of an approaching nervous breakdown is the  belief that one's work is terribly important.\"<br> -- Bertrand Russell (1872-1970)" +
"|\"A little inaccuracy sometimes saves a ton of explanation.\"<br> -- H. H. Munro (Saki) (1870-1916)" +
"|\"There are two ways of constructing a software design; one way is  to make it so simple that there are obviously no deficiencies,  and the other way is to make it so complicated that there are no  obvious deficiencies. The first method is far more difficult.\" <br> -- C. A. R. Hoare" +
"|\"Make everything as simple as possible, but not simpler.\"<br> -- Albert Einstein (1879-1955)" +
"|\"What do you take me for, an idiot?\"<br> -- General Charles de Gaulle (1890-1970), when a journalist     asked him if he was happy" +
"|\"I heard someone tried the monkeys-on-typewriters bit trying for  the plays of W. Shakespeare, but all they got was the collected  works of Francis Bacon.\"<br> -- Bill Hirst" +
"|\"Three o'clock is always too late or too early for anything you  want to do.\"<br> -- Jean-Paul Sartre (1905-1980)" +
"|\"A doctor can bury his mistakes but an architect can only advise  his clients to plant vines.\"<br> -- Frank Lloyd Wright (1868-1959)" +
"|\"It is dangerous to be sincere unless you are also stupid.\"    - George Bernard Shaw (1856-1950)" +
"|\"If you haven't got anything nice to say about anybody, come sit  next to me.\"<br> -- Alice Roosevelt Longworth (1884-1980)" +
"|\"A man can't be too careful in the choice of his enemies.\"<br> -- Oscar Wilde (1854-1900)" +
"|\"Forgive your enemies, but never forget their names.\"<br> -- John F. Kennedy (1917-1963)" +
"|\"Logic is in the eye of the logician.\"<br> -- Gloria Steinem" +
"|\"No one can earn a million dollars honestly.\"<br> -- William Jennings Bryan (1860-1925)" +
"|\"Everything has been figured out, except how to live.\"<br> -- Jean-Paul Sartre (1905-1980)" +
"|\"Well-timed silence hath more eloquence than speech.\"    - Martin Fraquhar Tupper" +
"|\"Thank you for sending me a copy of your book - I'll waste no  time reading it.\"<br> -- Moses Hadas (1900-1966)" +
"|\"From the moment I picked your book up until I laid it down I  was convulsed with laughter. Some day I intend reading it.\"<br> -- Groucho Marx (1895-1977)" +
"|\"It is better to have a permanent income than to be fascinating.\"<br> -- Oscar Wilde (1854-1900)" +
"|\"When ideas fail, words come in very handy.\"<br> -- Goethe (1749-1832)" +
"|\"In the end, everything is a gag.\"<br> -- Charlie Chaplin (1889-1977)" +
"|\"The nice thing about egotists is that they don't talk about  other people.\"<br> -- Lucille S. Harper" +
"|\"You got to be careful if you don't know where you're going,  because you might not get there.\"<br> -- Yogi Berra" +
"|\"I love Mickey Mouse more than any woman I have ever known.\"<br> -- Walt Disney (1901-1966)" +
"|\"He who hesitates is a damned fool.\"<br> -- Mae West (1892-1980)" +
"|\"Good teaching is one-fourth preparation and three-fourths  theater.\"<br> -- Gail Godwin" +
"|\"University politics are vicious precisely because the stakes  are so small.\"<br> -- Henry Kissinger (1923-)" +
"|\"The graveyards are full of indispensable men.\"<br> -- Charles de Gaulle (1890-1970)" +
"|\"You can pretend to be serious; you can't pretend to be witty.\"<br> -- Sacha Guitry (1885-1957)" +
"|\"Behind every great fortune there is a crime.\"<br> -- Honore de Balzac (1799-1850)" +
"|\"If women didn't exist, all the money in the world would have no  meaning.\"<br> -- Aristotle Onassis (1906-1975)" +
"|\"I am not young enough to know everything.\"<br> -- Oscar Wilde (1854-1900)" +
"|\"The object of war is not to die for your country but to make  the other bastard die for his.\"<br> -- General George Patton (1885-1945)" +
"|\"Sometimes a scream is better than a thesis.\"<br> -- Ralph Waldo Emerson (1803-1882)" +
"|\"There is no sincerer love than the love of food.\"<br> -- George Bernard Shaw (1856-1950)" +
"|\"I don't even butter my bread; I consider that cooking.\"<br> -- Katherine Cebrian" +
"|\"I have an existential map; it has 'you are here' written all  over it.\"<br> -- Steven Wright" +
"|\"Mr. Wagner has beautiful moments but bad quarters of an hour.\"    - Gioacchino Rossini (1792-1868)" +
"|\"Manuscript: something submitted in haste and returned at  leisure.\"<br> -- Oliver Herford (1863-1935)" +
"|\"I have read your book and much like it.\"<br> -- Moses Hadas (1900-1966)" +
"|\"The covers of this book are too far apart.\"<br> -- Ambrose Bierce (1842-1914)" +
"|\"Everywhere I go I'm asked if I think the university stifles  writers. My opinion is that they don't stifle enough of them.\"<br> -- Flannery O'Connor (1925-1964)" +
"|\"Too many pieces of music finish too long after the end.\"<br> -- Igor Stravinsky (1882-1971)" +
"|\"Anything that is too stupid to be spoken is sung.\"<br> -- Voltaire (1694-1778)" +
"|\"When choosing between two evils, I always like to try the one  I've never tried before.\"<br> -- Mae West (1892-1980)" +
"|\"I don't know anything about music. In my line you don't have  to.\"<br> -- Elvis Presley (1935-1977)" +
"|\"No Sane man will dance.\"<br> -- Cicero (106-43 B.C.)" +
"|\"Hell is a half-filled auditorium.\"<br> -- Robert Frost (1874-1963)" +
"|\"Show me a sane man and I will cure him for you.\"<br> -- Carl Gustav Jung (1875-1961)" +
"|\"Vote early and vote often.\"<br> -- Al Capone (1899-1947)" +
"|\"If I were two-faced, would I be wearing this one?\"<br> -- Abraham Lincoln (1809-1865)" +
"|\"Few things are harder to put up with than a good example.\"    - Mark Twain (1835-1910)" +
"|\"Hell is other people.\"<br> -- Jean-Paul Sartre (1905-1980)" +
"|\"I am become death, shatterer of worlds.\"<br> -- Robert J. Oppenheimer (1904-1967) (citing from the     Bhagavad Gita, after witnessing the world's first nuclear     explosion)" +
"|\"Happiness is good health and a bad memory.\"<br> -- Ingrid Bergman (1917-1982)" +
"|\"Friends may come and go, but enemies accumulate.\"<br> -- Thomas Jones" +
"|\"You can get more with a kind word and a gun than you can with a  kind word alone.\"<br> -- Al Capone (1899-1947)" +
"|\"The gods too are fond of a joke.\"<br> -- Aristotle (384-322 B.C.)" +
"|\"Distrust any enterprise that requires new clothes.\"<br> -- Henry David Thoreau (1817-1862)" +
"|\"The difference between pornography and erotica is lighting.\"<br> -- Gloria Leonard" +
"|\"It is time I stepped aside for a less experienced and less able  man.\"<br> -- Professor Scott Elledge on his retirement from Cornell" +
"|\"Every day I get up and look through the Forbes list of the  richest people in America. If I'm not there, I go to work.\"<br> -- Robert Orben" +
"|\"The cynics are right nine times out of ten.\"<br> -- Henry Louis Mencken (1880-1956)" +
"|\"There are some experiences in life which should not be demanded  twice from any man, and one of them is listening to the Brahms  Requiem.\"<br> -- George Bernard Shaw (1856-1950)" +
"|\"Attention to health is life's greatest hindrance.\"<br> -- Plato (427-347 B.C.)" +
"|\"Plato was a bore.\"<br> -- Friedrich Nietzsche (1844-1900)" +
"|\"Nietzsche was stupid and abnormal.\"<br> -- Leo Tolstoy (1828-1910)" +
"|\"I'm not going to get into the ring with Tolstoy.\"<br> -- Ernest Hemingway (1899-1961)" +
"|\"Hemingway was a jerk.\"<br> -- Harold Robbins " +
"|\"Men are not disturbed by things, but the view they take of  things.\"<br> -- Epictetus (55-135 A.D.)\"What about things like bullets?\"<br> -- Herb Kimmel, Behavioralist, Professor of Psychology, upon     hearing the above quote (1981)" +
"|\"How can I lose to such an idiot?\"<br> -- A shout from chessmaster Aaron Nimzovich (1886-1935)" +
"|\"I don't feel good.\"<br> -- The last words of Luther Burbank (1849-1926)" +
"|\"Nothing is wrong with California that a rise in the ocean level wouldn't cure.\"<br> -- Ross MacDonald (1915-1983)" +
"|\"Men have become the tools of their tools.\"<br> -- Henry David Thoreau (1817-1862)" +
"|\"I have never let my schooling interfere with my education.\"<br> -- Mark Twain (1835-1910)" +
"|\"It is now possible for a flight attendant to get a pilot  pregnant.\"<br> -- Richard J. Ferris, president of United Airlines" +
"|\"I never miss a chance to have sex or appear on television.\"<br> -- Gore Vidal" +
"|\"I don't want to achieve immortality through my work; I want to  achieve immortality through not dying.\"<br> -- Woody Allen (1935-)" +
"|\"Men and nations behave wisely once they have exhausted all the  other alternatives.\"<br> -- Abba Eban (1915-2002)" +
"|\"To sit alone with my conscience will be judgment enough for me.\"<br> -- Charles William Stubbs" +
"|\"Sanity is a madness put to good uses.\"<br> -- George Santayana (1863-1952)" +
"|\"Imitation is the sincerest form of television.\"<br> -- Fred Allen (1894-1956)" +
"|\"Always do right- this will gratify some and astonish the rest.\"<br> -- Mark Twain (1835-1910)" +
"|\"In America, anybody can be president. That's one of the risks  you take.\"<br> -- Adlai Stevenson (1900-1965)" +
"|\"Copy from one, it's plagiarism; copy from two, it's research.\"<br> -- Wilson Mizner (1876-1933)" +
"|\"Why don't you write books people can read?\"<br> -- Nora Joyce to her husband James (1882-1941)" +
"|\"Some editors are failed writers, but so are most writers.\"<br> -- T. S. Eliot (1888-1965)" +
"|\"Criticism is prejudice made plausible.\" <br> -- Henry Louis Mencken (1880-1956)" +
"|\"It is better to be quotable than to be honest.\"<br> -- Tom Stoppard" +
"|\"Being on the tightrope is living; everything else is waiting.\"<br> -- Karl Wallenda" +
"|\"Opportunities multiply as they are seized.\"<br> -- Sun Tzu" +
"|\"A scholar who cherishes the love of comfort is not fit to be  deemed a scholar.\"<br> -- Lao-Tzu (570?-490? BC)" +
"|\"The best way to predict the future is to invent it.\" <br> -- Alan Kay" +
"|\"Never mistake motion for action.\" <br> -- Ernest Hemingway (1899-1961)" +
"|\"Hell is paved with good samaritans.\"<br> -- William M. Holden" +
"|\"The longer I live the more I see that I am never wrong about  anything, and that all the pains that I have so humbly taken  to verify my notions have only wasted my time.\"<br> -- George Bernard Shaw (1856-1950)" +
"|\"Silence is argument carried out by other means.\"<br> -- Ernesto \"Che\" Guevara (1928-1967)" +
"|\"Well done is better than well said.\" <br> -- Benjamin Franklin (1706-1790)" +
"|\"The average person thinks he isn't.\"<br> -- Father Larry Lorenzoni" +
"|\"Heav'n hath no rage like love to hatred turn'd, Nor Hell a fury,  like a woman scorn'd.\"<br> -- William Congreve (1670-1729)" +
"|\"A husband is what is left of the lover after the nerve has been  extracted.\"<br> -- Helen Rowland (1876-1950)" +
"|\"Learning is what most adults will do for a living in the 21st  century.\"<br> -- Perelman" +
"|\"The man who goes alone can start today; but he who travels with  another must wait till that other is ready.\"<br> -- Henry David Thoreau (1817-1862)" +
"|\"There is a country in Europe where multiple-choice tests are  illegal.\"<br> -- Sigfried Hulzer" +
"|\"Ask her to wait a moment - I am almost done.\"<br> -- Carl Friedrich Gauss (1777-1855), while working, when     informed that his wife is dying" +
"|\"A pessimist sees the difficulty in every opportunity; an  optimist sees the opportunity in every difficulty.\"<br> -- Sir Winston Churchill (1874-1965)" +
"|\"I think there is a world market for maybe five computers.\"<br> -- Thomas Watson (1874-1956), Chairman of IBM, 1943" +
"|\"I think it would be a good idea.\"<br> -- Mahatma Gandhi (1869-1948), when asked what he thought of     Western civilization" +
"|\"The only thing necessary for the triumph of evil is for good  men to do nothing.\"<br> -- Edmund Burke (1729-1797)" +
"|\"I'm not a member of any organized political party, I'm a  Democrat!\"<br> -- Will Rogers (1879-1935)" +
"|\"If Stupidity got us into this mess, then why can't it get us  out?\"<br> -- Will Rogers (1879-1935)" +
"|\"The backbone of surprise is fusing speed with secrecy.\"<br> -- Von Clausewitz (1780-1831)" +
"|\"Democracy does not guarantee equality of conditions - it only  guarantees equality of opportunity.\"<br> -- Irving Kristol" +
"|\"There is no reason anyone would want a computer in their home.\"<br> -- Ken Olson, president, chairman and founder of Digital     Equipment Corp., 1977" +
"|\"640K ought to be enough for anybody.\"<br> -- Bill Gates (1955-), in 1981" +
"|\"The concept is interesting and well-formed, but in order to  earn better than a 'C', the idea must be feasible.\"<br> -- A Yale University management professor in response to student    Fred Smith's paper proposing reliable overnight delivery     service (Smith went on to found Federal Express Corp.)" +
"|\"Who the hell wants to hear actors talk?\"<br> -- H.M. Warner (1881-1958), founder of Warner Brothers,     in 1927" +
"|\"We don't like their sound, and guitar music is on the way out.\"<br> -- Decca Recording Co. rejecting the Beatles, 1962" +
"|\"Everything that can be invented has been invented.\"<br> -- Charles H. Duell, Commissioner, U.S. Office of Patents, 1899" +
"|\"Denial ain't just a river in Egypt.\"<br> -- Mark Twain (1835-1910)" +
"|\"A pint of sweat, saves a gallon of blood.\"<br> -- General George S. Patton (1885-1945)" +
"|\"After I'm dead I'd rather have people ask why I have no monument  than why I have one.\"<br> -- Cato the Elder (234-149 BC, AKA Marcus Porcius Cato)" +
"|\"He can compress the most words into the smallest idea of any  man I know.\"<br> -- Abraham Lincoln (1809-1865)" +
"|\"Don't let it end like this. Tell them I said something.\"<br> -- last words of Pancho Villa (1877-1923)" +
"|\"The right to swing my fist ends where the other man's nose  begins.\"<br> -- Oliver Wendell Holmes (1841-1935)" +
"|\"The difference between fiction and reality? Fiction has to make  sense.\"<br> -- Tom Clancy" +
"|\"It's not the size of the dog in the fight, it's the size of the  fight in the dog.\"<br> -- Mark Twain (1835-1910)" +
"|\"It is better to be feared than loved, if you cannot be both.\"<br> -- Niccolo Machiavelli (1469-1527), \"The Prince\"" +
"|\"Whatever is begun in anger ends in shame.\"<br> -- Benjamin Franklin (1706-1790)" +
"|\"The President has kept all of the promises he intended to keep.\"<br> -- Clinton aide George Stephanopolous speaking on Larry     King Live" +
"|\"We're going to turn this team around 360 degrees.\"<br> -- Jason Kidd, upon his drafting to the Dallas Mavericks" +
"|\"Half this game is ninety percent mental.\"<br> -- Yogi Berra" +
"|\"There is only one nature - the division into science and  engineering is a human imposition, not a natural one. Indeed,  the division is a human failure; it reflects our limited  capacity to comprehend the whole.\"<br> -- Bill Wulf" +
"|\"There's many a bestseller that could have been prevented by a  good teacher.\"<br> -- Flannery O'Connor (1925-1964)" +
"|\"He has all the virtues I dislike and none of the vices I admire.\"<br> -- Sir Winston Churchill (1874-1965)" +
"|\"I criticize by creation - not by finding fault.\" <br> -- Cicero (106-43 B.C.)" +
"|\"Love is friendship set on fire.\"<br> -- Jeremy Taylor" +
"|\"God gave men both a penis and a brain, but unfortunately not  enough blood supply to run both at the same time.\"<br> -- Robin Williams, commenting on the Clinton/Lewinsky affair" +
"|\"My occupation now, I suppose, is jail inmate.\"<br> -- Unibomber Theodore Kaczynski, when asked in court what his     current profession was" +
"|\"Woman was God's second mistake.\"<br> -- Friedrich Nietzsche (1844-1900)" +
"|\"This isn't right, this isn't even wrong.\"<br> -- Wolfgang Pauli (1900-1958), upon reading a young physicist's     paper" +
"|\"For centuries, theologians have been explaining the unknowable  in terms of the-not-worth-knowing.\"<br> -- Henry Louis Mencken (1880-1956)" +
"|\"Pray, v.: To ask that the laws of the universe be annulled on  behalf of a single petitioner confessedly unworthy.\"<br> -- Ambrose Bierce (1842-1914)" +
"|\"Every normal man must be tempted at times to spit upon his  hands, hoist the black flag, and begin slitting throats.\"<br> -- Henry Louis Mencken (1880-1956)" +
"|\"Now, now my good man, this is no time for making enemies.\"<br> -- Voltaire (1694-1778) on his deathbed in response to a priest     asking that he renounce Satan" +
"|\"Fill the unforgiving minute with sixty seconds worth of  distance run.\"<br> -- Rudyard Kipling (1865-1936)" +
"|\"He would make a lovely corpse.\"<br> -- Charles Dickens (1812-1870)" +
"|\"I've just learned about his illness. Let's hope it's nothing  trivial.\"<br> -- Irvin S. Cobb" +
"|\"I worship the quicksand he walks in.\"<br> -- Art Buchwald" +
"|\"Wagner's music is better than it sounds.\"<br> -- Mark Twain (1835-1910)" +
"|\"A poem is never finished, only abandoned.\"<br> -- Paul Valery (1871-1945)" +
"|\"We are not retreating - we are advancing in another Direction.\"<br> -- General Douglas MacArthur (1880-1964)" +
"|\"If you were plowing a field, which would you rather use? Two  strong oxen or 1024 chickens?\"<br> -- Seymour Cray (1925-1996), father of supercomputing" +
"|\"#3 pencils and quadrille pads.\"<br> -- Seymoure Cray (1925-1996) when asked what CAD tools he used     to design the Cray I supercomputer; he also recommended using     the back side of the pages so that the lines were not so     dominant" +
"|\"I just bought a Mac to help me design the next Cray.\"<br> -- Seymoure Cray (1925-1996) when was informed that Apple Inc.     had recently bought a Cray supercomputer to help them design     the next Mac" +
"|\"Your Highness, I have no need of this hypothesis.\"<br> -- Pierre Laplace (1749-1827), to Napoleon on why his works on     celestial mechanics make no mention of God" +
"|\"I choose a block of marble and chop off whatever I don't need.\"<br> -- Francois-Auguste Rodin (1840-1917), when asked how he managed    to make his remarkable statues" +
"|\"The man who does not read good books has no advantage over the  man who cannot read them.\"<br> -- Mark Twain (1835-1910)" +
"|\"The truth is more important than the facts.\"<br> -- Frank Lloyd Wright (1868-1959)" +
"|\"Research is what I'm doing when I don't know what I'm doing.\"<br> -- Wernher Von Braun (1912-1977)" +
"|\"There are only two tragedies in life: one is not getting what  one wants, and the other is getting it.\"<br> -- Oscar Wilde (1854-1900)" +
"|\"There are only two ways to live your life. One is as though  nothing is a miracle. The other is as though everything is a  miracle.\"<br> -- Albert Einstein (1879-1955)" +
"|\"Be tolerant of the human race.  Your whole family belongs to it <br> -- and some of your spouse's family too.\"<br> -- Anonymous" +
"|\"Mother-in-law = A woman who destroys her son-in-law's peace of  mind by giving him a piece of hers.\"<br> -- Anonymous" +
"|\"Why do grandparents and grandchildren get along so well?  They  have the same enemy<br> -- the mother.\"<br> -- Claudette Colbert" +
"|\"The first half of our life is ruined by our parents and the  second half by our children.\"<br> -- Clarence Darrow" +
"|\"Honolulu, it's got everything.  Sand for the children, sun for  the wife, and sharks for the wife's mother.\"<br> -- Ken Dodd" +
"|\"A coward is a hero with a wife, kids, and a mortgage.\" <br> -- Marvin Kitman" +
"|\"A man can't get rich if he takes proper care of his family.\"  - Navaho saying" +
"|\"Giving birth is like taking your lower lip and forcing it over your head.\" - Carol Burnett" +
"|\"You have to stay in shape.  My grandmother, she started walking  five miles a day when she was 60.  She's 97 today and we don't  know where she is!\"<br> -- Ellen DeGeneres" +
"|\"I'm not into working out.  My philosophy: No pain, no pain.\" <br> -- Carol Leifer" +
"|\"You have a cough?  Go home tonight, eat a whole box of Ex-Lax <br> -- tomorrow you'll be afraid to cough.\"<br> -- Pearl Williams" +
"|\"Now comes the mystery\" <br> -- Henry Ward Beecher, dying words, March 8, 1887" +
"|\"I don't feel good.\"<br> -- Luther Burbank, dying words" +
"|\"The nourishment is palatable\"<br> -- Emily Dickinson, dying words" +
"|\"Dieu me pardonnera. C'est son métier.\"  Translation: God forgive me. It's his job.<br> -- Heinrich Heine, dying words" +
"|\"Go on, get out.  Last words are for fools who haven't said  enough.\"<br> -- Karl Marx, dying words to his housekeeper" +
"|\"Why yes<br> -- a bulletproof vest.\" <br> -- James Rodges, murderer, on his final request before the     firing squad" +
"|\"They couldn't hit an elephant at this dist--\" <br> -- John B. Sedwick, general, dying words, 1864" +
"|\"I still live.\"<br> -- Daniel Webster, dying words" +
"|\"Go away...I'm alright.\"<br> -- H.G.Wells, dying words" +
"|\"Friends applaud, the Comedy is over.\" <br> -- Ludwig von Beethoven, dying words" +
"|\"Ah well, then I suppose I shall have to die beyond my means.\" <br> -- Oscar Wilde, dying words" +
"|\"I agree with the reforms, but I want nothing to change\"<br> -- Ion Luca Caragiale, Romanian playwriter, 1880" +
"|\"Far too many development shops are run by fools who succeed  despite their many failings.\"<br> -- Brion L. Webster" +
"|\"Never raise your hands to your kids. It leaves your groin unprotected.\"<br> -- Red Button" +
"|\"I'm in shape. Round is a shape.\"<br> -- George Carlin" +
"|\"Do illiterate people get the full effect of alphabet soup?\" <br> -- John Mendoza" +
"|\"I've always wanted to be somebody, but I should have been more specific.\"<br> -- George Carlin" +
"|\"Ever notice when you blow in a dog's face he gets mad at you,  but when you take him in a car he sticks his head out the  window?\"<br> -- George Carlin" +
"|\"Ever notice that anyone going slower than you is an idiot, but  anyone going faster is a maniac?\"<br> -- George Carlin" +
"|\"I have six locks on my door, all in a row. When I go out, I  lock every other one. I figure no matter how long somebody  stands there picking the locks, they are always locking three  of them.\"<br> -- George Carlin" +
"|\"One out of every three Americans is suffering from some form of mental illness. Think of two of your best friends. If they are  OK, then it must be you.\"<br> -- George Carlin" +
"|\"They show you how detergents take out bloodstains. I think if  you've got a T-shirt with bloodstains all over it, maybe your  laundry isn't your biggest problem.\"<br> -- George Carlin" +
"|\"Ask people why they have deer heads on their walls and they  tell you it's because they're such beautiful animals. I think  my wife is beautiful, but I only have photographs of her on the  wall.\"<br> -- George Carlin" +
"|\"A lady came up to me on the street, pointed at my suede jacket  and said, 'Don't you know a cow was murdered for that jacket?'  I said 'I didn't know there were any witnesses. Now I'll have to  kill you too'.\"<br> -- George Carlin" +
"|\"Future historians will be able to study at the Jimmy Carter  Library, the Gerald Ford Library, the Ronald Reagan Library,  and the Bill Clinton Adult Bookstore.\"<br> -- George Carlin. ";
    }
}