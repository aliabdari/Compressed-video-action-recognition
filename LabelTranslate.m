function out = LabelTranslate(label,dataset)
dataset = string(dataset);
label = string(label);
if(contains(dataset,'Dogcentric'))
    switch label
        case 'Car'
            out=1;
        case 'Drink'
            out=2;
        case 'Feed'
            out=3;
        case 'Look_at_Left'
            out=4;
        case 'Look_at_Right'
            out=5;
        case 'Pet'
            out=6;
        case 'Play_with_ball'
            out=7;
        case 'Shake'
            out=8;
        case 'Sniff'
            out=9;
        case 'Walk'
            out=10;
        otherwise
            out = str2num(char(label));
    end
elseif(contains(dataset,'KTH'))
    switch label
        case 'boxing'
            out=1;
        case {'handclapping','handclaping'}
            out=2;
        case 'handwaving'
            out=3;
        case 'jogging'
            out=4;
        case 'running'
            out=5;
        case 'walking'
            out=6;
        otherwise
            out = str2num(char(label));
    end
elseif(contains(dataset,'youtubeDog'))
    switch label
        case 'chase_something'
            out=1;
        case 'drink'
            out=2;
        case 'follow'
            out=3;
        case 'inside_car'
            out=4;
        case 'jump'
            out=5;
        case 'look_left'
            out=6;
        case 'look_right'
            out=7;
        case 'pat_kiss_hug'
            out=8;
        case 'play_ball'
            out=9;
        case 'run'
            out=10;
        case 'shake_body'
            out=11;
        case 'sniff'
            out=12;
        case 'stairs'
            out=13;
        case 'swim'
            out=14;
        case 'wait'
            out=15;
        case 'walk_city'
            out=16;
        case 'walk_indoor'
            out=17;
        case 'walk_offroad'
            out=18;
        case 'wave_cheer_point'
            out=19;
        otherwise
            out = str2num(char(label));
    end
elseif(contains(dataset,'UCF50'))
    switch label
        case 'BaseballPitch'
            out=1;
        case 'Basketball'
            out=2;
        case 'BenchPress'
            out=3;
        case 'Biking'
            out=4;
        case 'Billiards'
            out=5;
        case 'BreastStroke'
            out=6;
        case 'CleanAndJerk'
            out=7;
        case 'Diving'
            out=8;
        case 'Drumming'
            out=9;
        case 'Fencing'
            out=10;
        case 'GolfSwing'
            out=11;
        case 'HighJump'
            out=12;
        case 'HorseRace'
            out=13;
        case 'HorseRiding'
            out=14;
        case 'HulaHoop'
            out=15;
        case 'JavelinThrow'
            out=16;
        case 'JugglingBalls'
            out=17;
        case 'JumpingJack'
            out=18;
        case 'JumpRope'
            out=19;
        case 'Kayaking'
            out=20;
        case 'Lunges'
            out=21;
        case 'MilitaryParade'
            out=22;
        case 'Mixing'
            out=23;
        case 'Nunchucks'
            out=24;
        case 'PizzaTossing'
            out=25;
        case 'PlayingGuitar'
            out=26;
        case 'PlayingPiano'
            out=27;
        case 'PlayingTabla'
            out=28;
        case 'PlayingViolin'
            out=29;
        case 'PoleVault'
            out=30;
        case 'PommelHorse'
            out=31;
        case 'PullUps'
            out=32;
        case 'Punch'
            out=33;
        case 'PushUps'
            out=34;
        case 'RockClimbingIndoor'
            out=35;
        case 'RopeClimbing'
            out=36;
        case 'Rowing'
            out=37;
        case 'SalsaSpin'
            out=38;
        case 'SkateBoarding'
            out=39;
        case 'Skiing'
            out=40;
        case 'Skijet'
            out=41;
        case 'SoccerJuggling'
            out=42;
        case 'Swing'
            out=43;
        case 'TaiChi'
            out=44;
        case 'TennisSwing'
            out=45;
        case 'ThrowDiscus'
            out=46;
        case 'TrampolineJumping'
            out=47;
        case 'VolleyballSpiking'
            out=48;
        case 'WalkingWithDog'
            out=49;
        case 'YoYo'
            out=50;
        otherwise
            out = str2num(char(label));
    end
elseif(contains(dataset,'tv_human'))
    switch label
        case 'HandShake'
            out=1;
        case 'HighFive'
            out=2;
        case 'Hug'
            out=3;
        case 'Kiss'
            out=4;
        case 'Negative1'
            out=5;
        otherwise
            out = str2num(char(label));
    end
else
    out=str2num(char(label));
end
end