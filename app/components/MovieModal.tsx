import React from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from './ui/dialog';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { Card, CardContent } from './ui/card';
import { Star, ThumbsUp, ThumbsDown, Play, Calendar, Clock, Globe } from 'lucide-react';

interface Movie {
  id: number;
  title: string;
  poster: string;
  year: number;
  genre: string[];
  rating: number;
  votes: {
    upvotes: number;
    downvotes: number;
  };
  description: string;
  director?: string;
  cast?: string[];
  duration?: number;
  language?: string;
}

interface MovieModalProps {
  movie: Movie | null;
  isOpen: boolean;
  onClose: () => void;
  onUpvote: (movieId: number) => void;
  onDownvote: (movieId: number) => void;
  recommendations?: Movie[];
}

const MovieModal: React.FC<MovieModalProps> = ({ 
  movie, 
  isOpen, 
  onClose, 
  onUpvote, 
  onDownvote,
  recommendations = []
}) => {
  if (!movie) return null;

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-4xl max-h-[90vh] overflow-y-auto bg-slate-900 border-slate-700 text-white">
        <DialogHeader>
          <DialogTitle className="text-2xl font-bold text-white">
            {movie.title}
          </DialogTitle>
        </DialogHeader>

        <div className="space-y-6">
          {/* Movie Details Section */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Poster */}
            <div className="space-y-4">
              <img 
                src={movie.poster} 
                alt={movie.title}
                className="w-full rounded-lg shadow-lg"
              />
              
              {/* Action Buttons */}
              <div className="space-y-2">
                <Button className="w-full bg-red-600 hover:bg-red-700 text-white">
                  <Play className="h-5 w-5 mr-2" />
                  Watch Trailer
                </Button>
                
                <div className="flex gap-2">
                  <Button
                    variant="outline"
                    className="flex-1 border-green-500 text-green-500 hover:bg-green-500 hover:text-white"
                    onClick={() => onUpvote(movie.id)}
                  >
                    <ThumbsUp className="h-4 w-4 mr-1" />
                    {movie.votes.upvotes}
                  </Button>
                  <Button
                    variant="outline"
                    className="flex-1 border-red-500 text-red-500 hover:bg-red-500 hover:text-white"
                    onClick={() => onDownvote(movie.id)}
                  >
                    <ThumbsDown className="h-4 w-4 mr-1" />
                    {movie.votes.downvotes}
                  </Button>
                </div>
              </div>
            </div>

            {/* Movie Info */}
            <div className="md:col-span-2 space-y-4">
              {/* Rating and Meta Info */}
              <div className="flex flex-wrap items-center gap-4">
                <Badge className="bg-yellow-500 text-black font-bold text-lg px-3 py-1">
                  <Star className="h-4 w-4 mr-1" />
                  {movie.rating}
                </Badge>
                
                <div className="flex items-center text-slate-400">
                  <Calendar className="h-4 w-4 mr-1" />
                  {movie.year}
                </div>
                
                {movie.duration && (
                  <div className="flex items-center text-slate-400">
                    <Clock className="h-4 w-4 mr-1" />
                    {movie.duration} min
                  </div>
                )}
                
                {movie.language && (
                  <div className="flex items-center text-slate-400">
                    <Globe className="h-4 w-4 mr-1" />
                    {movie.language}
                  </div>
                )}
              </div>

              {/* Genres */}
              <div className="flex flex-wrap gap-2">
                {movie.genre.map((genre) => (
                  <Badge key={genre} variant="secondary">
                    {genre}
                  </Badge>
                ))}
              </div>

              {/* Description */}
              <div>
                <h3 className="text-lg font-semibold mb-2">Overview</h3>
                <p className="text-slate-300 leading-relaxed">
                  {movie.description}
                </p>
              </div>

              {/* Cast and Crew */}
              {movie.director && (
                <div>
                  <h3 className="text-lg font-semibold mb-2">Director</h3>
                  <p className="text-slate-300">{movie.director}</p>
                </div>
              )}

              {movie.cast && movie.cast.length > 0 && (
                <div>
                  <h3 className="text-lg font-semibold mb-2">Cast</h3>
                  <p className="text-slate-300">{movie.cast.join(', ')}</p>
                </div>
              )}
            </div>
          </div>

          {/* Recommendations Section */}
          {recommendations.length > 0 && (
            <div>
              <h3 className="text-xl font-bold mb-4 text-white">
                Recommended for You
              </h3>
              <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
                {recommendations.map((rec) => (
                  <Card key={rec.id} className="bg-slate-800 border-slate-700 hover:bg-slate-700 transition-colors cursor-pointer">
                    <CardContent className="p-3">
                      <img 
                        src={rec.poster} 
                        alt={rec.title}
                        className="w-full aspect-[2/3] object-cover rounded mb-2"
                      />
                      <h4 className="text-white text-sm font-medium truncate">
                        {rec.title}
                      </h4>
                      <p className="text-slate-400 text-xs">{rec.year}</p>
                      <div className="flex items-center mt-1">
                        <Star className="h-3 w-3 text-yellow-500 mr-1" />
                        <span className="text-xs text-slate-300">{rec.rating}</span>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default MovieModal;
