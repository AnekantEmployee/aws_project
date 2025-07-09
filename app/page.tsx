'use client'
import React, { useState, useEffect } from 'react';
import { Button } from './components/ui/button';
import { Badge } from './components/ui/badge';
import { Star, TrendingUp, Film, Sparkles } from 'lucide-react';
import { useToast } from './hooks/use-toast';
import MovieCard from './components/MovieCard';
import SearchBar from './components/SearchBar';
import MovieModal from './components/MovieModal';

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

const Index = () => {
  const { toast } = useToast();
  const [selectedMovie, setSelectedMovie] = useState<Movie | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [searchResults, setSearchResults] = useState<Movie[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [movies, setMovies] = useState<Movie[]>([]);

  // Sample movie data - in real app this would come from your API
  const sampleMovies: Movie[] = [
    {
      id: 1,
      title: "The Matrix",
      poster: "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=600&fit=crop",
      year: 1999,
      genre: ["Action", "Science Fiction"],
      rating: 8.7,
      votes: { upvotes: 1240, downvotes: 89 },
      description: "A computer programmer discovers that reality as he knows it is actually a simulation, and he joins a rebellion to free humanity from their digital prison.",
      director: "The Wachowskis",
      cast: ["Keanu Reeves", "Laurence Fishburne", "Carrie-Anne Moss"],
      duration: 136,
      language: "English"
    },
    {
      id: 2,
      title: "Inception",
      poster: "https://images.unsplash.com/photo-1500673922987-e212871fec22?w=400&h=600&fit=crop",
      year: 2010,
      genre: ["Action", "Thriller", "Science Fiction"],
      rating: 8.8,
      votes: { upvotes: 2150, downvotes: 145 },
      description: "A thief who enters people's dreams to steal secrets is given the inverse task of planting an idea in someone's mind.",
      director: "Christopher Nolan",
      cast: ["Leonardo DiCaprio", "Marion Cotillard", "Tom Hardy"],
      duration: 148,
      language: "English"
    },
    {
      id: 3,
      title: "Interstellar",
      poster: "https://images.unsplash.com/photo-1500375592092-40eb2168fd21?w=400&h=600&fit=crop",
      year: 2014,
      genre: ["Drama", "Science Fiction"],
      rating: 8.6,
      votes: { upvotes: 1890, downvotes: 201 },
      description: "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival.",
      director: "Christopher Nolan",
      cast: ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain"],
      duration: 169,
      language: "English"
    },
    {
      id: 4,
      title: "Blade Runner 2049",
      poster: "https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400&h=600&fit=crop",
      year: 2017,
      genre: ["Action", "Science Fiction", "Drama"],
      rating: 8.0,
      votes: { upvotes: 987, downvotes: 156 },
      description: "A young blade runner's discovery of a long-buried secret leads him to track down former blade runner Rick Deckard.",
      director: "Denis Villeneuve",
      cast: ["Ryan Gosling", "Harrison Ford", "Ana de Armas"],
      duration: 164,
      language: "English"
    },
    {
      id: 5,
      title: "Dune",
      poster: "https://images.unsplash.com/photo-1500673922987-e212871fec22?w=400&h=600&fit=crop",
      year: 2021,
      genre: ["Adventure", "Science Fiction", "Drama"],
      rating: 8.1,
      votes: { upvotes: 1456, downvotes: 234 },
      description: "Paul Atreides leads nomadic tribes in a revolt against the evil House Harkonnen in their struggle for control of the desert planet Arrakis.",
      director: "Denis Villeneuve",
      cast: ["Timothée Chalamet", "Rebecca Ferguson", "Oscar Isaac"],
      duration: 155,
      language: "English"
    },
    {
      id: 6,
      title: "Avatar",
      poster: "https://images.unsplash.com/photo-1500375592092-40eb2168fd21?w=400&h=600&fit=crop",
      year: 2009,
      genre: ["Action", "Adventure", "Science Fiction"],
      rating: 7.9,
      votes: { upvotes: 2340, downvotes: 423 },
      description: "A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.",
      director: "James Cameron",
      cast: ["Sam Worthington", "Zoe Saldana", "Sigourney Weaver"],
      duration: 162,
      language: "English"
    }
  ];

  useEffect(() => {
    setMovies(sampleMovies);
  }, []);

  const handleMovieClick = (movie: Movie) => {
    setSelectedMovie(movie);
    setIsModalOpen(true);
    
    // Generate sample recommendations (in real app, this would be AI-powered)
    const recommendations = sampleMovies
      .filter(m => m.id !== movie.id)
      .filter(m => m.genre.some(g => movie.genre.includes(g)))
      .slice(0, 5);
    
    setSelectedMovie({...movie, recommendations});
  };

  const handleUpvote = (movieId: number) => {
    setMovies(prev => prev.map(movie => 
      movie.id === movieId 
        ? { ...movie, votes: { ...movie.votes, upvotes: movie.votes.upvotes + 1 } }
        : movie
    ));
    
    toast({
      title: "Upvoted!",
      description: "Thanks for your feedback!",
    });
  };

  const handleDownvote = (movieId: number) => {
    setMovies(prev => prev.map(movie => 
      movie.id === movieId 
        ? { ...movie, votes: { ...movie.votes, downvotes: movie.votes.downvotes + 1 } }
        : movie
    ));
    
    toast({
      title: "Downvoted",
      description: "Thanks for your feedback!",
    });
  };

  const handleSearch = (query: string, filters?: any) => {
    setIsSearching(true);
    
    // Simulate search API call
    setTimeout(() => {
      const results = sampleMovies.filter(movie => 
        movie.title.toLowerCase().includes(query.toLowerCase()) ||
        movie.genre.some(g => g.toLowerCase().includes(query.toLowerCase())) ||
        movie.director?.toLowerCase().includes(query.toLowerCase())
      );
      
      setSearchResults(results);
      setIsSearching(false);
      
      toast({
        title: `Found ${results.length} movies`,
        description: `Search results for "${query}"`,
      });
    }, 1000);
  };

  const handleClearSearch = () => {
    setSearchResults([]);
    setIsSearching(false);
  };

  const featuredMovie = movies[0];
  const displayMovies = searchResults.length > 0 ? searchResults : movies;
  const recommendations = selectedMovie ? sampleMovies.filter(m => 
    m.id !== selectedMovie.id && 
    m.genre.some(g => selectedMovie.genre.includes(g))
  ).slice(0, 5) : [];

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 text-white">
      {/* Hero Section */}
      {!isSearching && searchResults.length === 0 && featuredMovie && (
        <div className="relative h-[70vh] overflow-hidden">
          <div className="absolute inset-0">
            <img 
              src={featuredMovie.poster} 
              alt={featuredMovie.title}
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-r from-black/80 via-black/40 to-transparent" />
            <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
          </div>
          
          <div className="relative z-10 flex items-center h-full max-w-7xl mx-auto px-6">
            <div className="max-w-2xl space-y-6">
              <div className="flex items-center gap-2 mb-4">
                <Badge className="bg-red-600 text-white">
                  <TrendingUp className="h-4 w-4 mr-1" />
                  Featured
                </Badge>
                <Badge className="bg-yellow-500 text-black font-bold">
                  <Star className="h-4 w-4 mr-1" />
                  {featuredMovie.rating}
                </Badge>
              </div>
              
              <h1 className="text-5xl lg:text-7xl font-bold leading-tight">
                {featuredMovie.title}
              </h1>
              
              <div className="flex flex-wrap gap-2 mb-4">
                {featuredMovie.genre.map((genre) => (
                  <Badge key={genre} variant="outline" className="border-white/30 text-white">
                    {genre}
                  </Badge>
                ))}
              </div>
              
              <p className="text-xl text-slate-200 leading-relaxed max-w-xl">
                {featuredMovie.description}
              </p>
              
              <div className="flex gap-4">
                <Button 
                  size="lg" 
                  className="bg-red-600 hover:bg-red-700 text-white px-8 py-4 text-lg"
                  onClick={() => handleMovieClick(featuredMovie)}
                >
                  <Film className="h-6 w-6 mr-2" />
                  View Details
                </Button>
                <Button 
                  size="lg" 
                  variant="outline" 
                  className="border-white/30 text-white hover:bg-white/10 px-8 py-4 text-lg"
                >
                  <Sparkles className="h-6 w-6 mr-2" />
                  Get Recommendations
                </Button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Search Section */}
      <div className="py-12 px-6">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-8">
            <h2 className="text-3xl font-bold mb-4">
              Discover Your Next Favorite Movie
            </h2>
            <p className="text-slate-400 text-lg">
              Search through thousands of movies and get personalized recommendations
            </p>
          </div>
          
          <SearchBar onSearch={handleSearch} onClear={handleClearSearch} />
        </div>
      </div>

      {/* Movies Grid */}
      <div className="py-12 px-6">
        <div className="max-w-7xl mx-auto">
          <div className="flex items-center justify-between mb-8">
            <h2 className="text-2xl font-bold">
              {searchResults.length > 0 ? 'Search Results' : 'Popular Movies'}
            </h2>
            {displayMovies.length > 0 && (
              <Badge variant="secondary" className="text-sm">
                {displayMovies.length} movies
              </Badge>
            )}
          </div>
          
          {isSearching ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {[...Array(8)].map((_, i) => (
                <div key={i} className="animate-pulse">
                  <div className="bg-slate-700 aspect-[2/3] rounded-lg mb-4"></div>
                  <div className="bg-slate-700 h-4 rounded mb-2"></div>
                  <div className="bg-slate-700 h-3 rounded w-3/4"></div>
                </div>
              ))}
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {displayMovies.map((movie) => (
                <MovieCard 
                  key={movie.id}
                  movie={movie}
                  onMovieClick={handleMovieClick}
                  onUpvote={handleUpvote}
                  onDownvote={handleDownvote}
                />
              ))}
            </div>
          )}
          
          {!isSearching && displayMovies.length === 0 && (
            <div className="text-center py-12">
              <Film className="h-16 w-16 text-slate-600 mx-auto mb-4" />
              <h3 className="text-xl font-semibold text-slate-400 mb-2">
                No movies found
              </h3>
              <p className="text-slate-500">
                Try adjusting your search criteria
              </p>
            </div>
          )}
        </div>
      </div>

      {/* Movie Modal */}
      <MovieModal 
        movie={selectedMovie}
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onUpvote={handleUpvote}
        onDownvote={handleDownvote}
        recommendations={recommendations}
      />
    </div>
  );
};

export default Index;
