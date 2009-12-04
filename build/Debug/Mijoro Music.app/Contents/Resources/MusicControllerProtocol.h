/*
 *  MusicControllerProtocol.h
 *  MijoroMusic
 *
 *  Created by Michael Feldstein on 4/2/09.
 *  Copyright 2009 Mijoro All rights reserved.
 *
 */
@protocol MusicControllerProtocol

- (void) nextTrack;
- (void) previousTrack;
- (void) playPause;
- (void) showApp;
- (BOOL) currentState;
- (void) setDelegate:(id)delegate;
- (NSString *) appName;
+ (NSString *) appName;
@end


@protocol MusicControllerDelegate
//Set the controllers playing/paused state
- (void) setPlayerState:(BOOL)playing withSong:(NSString*)song artist:(NSString*)artist artwork:(NSData*)artwork;

//Let the delegate know that a new song has come on
//so it can put up a notification
//- (void) playerEvent:(MJMusicEvent *)event;
@end