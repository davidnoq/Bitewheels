# BiteWheels 🚚

A comprehensive full-stack food truck event management platform that connects event organizers with food truck owners through an innovative credit-based application system.

## 🚀 Features

### Core Functionality
- **Event Management**: Create, publish, and manage food truck events with detailed information
- **Food Truck Applications**: Credit-based application system for food truck owners to apply to events
- **Real-time Communication**: Live chat between event organizers and food truck owners
- **AI Integration**: Automated event photo generation using OpenAI's DALL-E
- **Payment Processing**: Secure Stripe integration for credit purchases and applications
- **Geospatial Search**: Location-based event discovery and food truck proximity
- **Progressive Web App**: Offline capabilities and mobile-optimized experience

### User Roles & Permissions
- **Event Organizers**: Create events, manage applications, communicate with food truck owners
- **Food Truck Owners**: Apply to events, manage profile, communicate with organizers
- **Regular Users**: Browse events, purchase credits, rate food trucks

## 🛠 Tech Stack

### Backend
- **Ruby on Rails 7.2.1** - Modern web framework with API-first design
- **Ruby 3.3.0** - Latest stable Ruby version
- **PostgreSQL** - Primary database with geospatial capabilities
- **Redis** - Caching and ActionCable support
- **Puma** - High-performance web server

### Frontend
- **Hotwire (Turbo + Stimulus)** - Modern Rails approach to reactive UIs
- **Bootstrap 5.3.3** - Responsive design system
- **ESBuild** - Fast JavaScript bundling
- **Sass/PostCSS** - Advanced CSS preprocessing
- **Progressive Web App** - Service worker implementation

### Real-time & Communication
- **ActionCable** - WebSocket implementation for live chat
- **Custom Channel Architecture** - Real-time notifications system

### External Services
- **Stripe** - Payment processing
- **OpenAI DALL-E** - AI-powered image generation
- **Mailgun** - Transactional email service
- **Geocoding API** - Address-to-coordinates conversion
- **Firebase Admin SDK** - Push notifications

### DevOps & Deployment
- **Docker** - Containerized application with multi-stage builds
- **Background Jobs** - Asynchronous task processing
- **Cron Jobs** - Scheduled tasks using Whenever gem

## 📋 Prerequisites

- Ruby 3.3.0
- Node.js 18.11.0+
- PostgreSQL 12+
- Redis 6+
- Docker (optional, for containerized deployment)

## 🚀 Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/davidnoq/Bitewheels.git
   cd Bitewheels
   ```

2. **Install dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Set up the database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Configure environment variables**
   Create a `.env` file with the following variables:
   ```env
   OPENAI_API_KEY=your_openai_api_key
   STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
   STRIPE_SECRET_KEY=your_stripe_secret_key
   MAILGUN_API_KEY=your_mailgun_api_key
   MAILGUN_DOMAIN=your_mailgun_domain
   ```

5. **Start the application**
   ```bash
   rails server
   ```

6. **Access the application**
   Open your browser and navigate to `http://localhost:3000`

### Docker Deployment

1. **Build the Docker image**
   ```bash
   docker build -t bitewheels .
   ```

2. **Run the container**
   ```bash
   docker run -p 3000:3000 -e RAILS_MASTER_KEY=your_master_key bitewheels
   ```

## 🏗 Project Structure

```
app/
├── controllers/          # Rails controllers
├── models/              # ActiveRecord models
├── views/               # ERB templates and Jbuilder APIs
├── services/            # Business logic services
├── jobs/                # Background job processing
├── policies/            # Pundit authorization policies
├── javascript/          # Stimulus controllers and channels
└── assets/              # SCSS stylesheets and images

config/
├── routes.rb            # Application routes
├── initializers/        # Service configurations
└── environments/        # Environment-specific settings

db/
├── migrate/             # Database migrations
└── schema.rb           # Database schema
```

## 🔧 Key Features Implementation

### Real-time Chat System
- WebSocket-based communication using ActionCable
- Channel-based architecture for event-specific conversations
- Auto-scrolling message display and form handling

### AI Photo Generation
- OpenAI DALL-E integration for event photos
- Automated background job processing
- Fallback to manual photo upload

### Credit System
- Stripe-powered payment processing
- Credit-based application system
- Automated credit deduction and refunds

### Geospatial Features
- Address geocoding for events and food trucks
- Location-based event searching
- Proximity-based recommendations

## 🧪 Testing

```bash
# Run the test suite
rails test

# Run system tests
rails test:system

# Run with coverage
COVERAGE=true rails test
```

## 📱 Mobile & PWA

The application is fully responsive and includes Progressive Web App capabilities:
- Service worker for offline functionality
- App manifest for mobile installation
- Push notification support

## 🔒 Security Features

- **Authentication**: Devise-based user authentication
- **Authorization**: Pundit policy-based access control
- **CSRF Protection**: Rails built-in CSRF tokens
- **Content Security Policy**: XSS protection
- **Parameter Filtering**: Secure logging practices
- **SQL Injection Prevention**: ActiveRecord ORM protection

## 🚀 Deployment

### Production Environment
- Docker containerization for consistent deployment
- Asset precompilation and optimization
- Database connection pooling
- Redis caching layer
- Background job processing

### Environment Variables
Ensure the following environment variables are set in production:
- `RAILS_MASTER_KEY`
- `DATABASE_URL`
- `REDIS_URL`
- `OPENAI_API_KEY`
- `STRIPE_SECRET_KEY`
- `MAILGUN_API_KEY`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**David** - Full-stack developer
- GitHub: [@davidnoq](https://github.com/davidnoq)

## 🙏 Acknowledgments

- Ruby on Rails community
- Bootstrap team for the UI framework
- OpenAI for AI integration capabilities
- Stripe for payment processing
- All open-source contributors
