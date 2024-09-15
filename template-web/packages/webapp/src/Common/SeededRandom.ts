import { TextAreaUserType } from 'src/Common/TextAreaForm';

class SeededRandom {
  private state: number;

  constructor(seed: string, user: TextAreaUserType) {
    const userString = `${user.name} ${user.nickname} ${user.countryCode} ${user.admin1Name} ${user.admin2Name} ${user.lat} ${user.lng} ${user.birthday}`;
    this.state = this.hash(seed + this.getCurrentTimeString() + userString);
    if (this.state === 0) this.state = 1; // Ensure non-zero state
  }

  private getCurrentTimeString(): string {
    const now = new Date();
    return now.toISOString();
  }

  private hash(str: string): number {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = (hash << 5) - hash + char;
      hash = hash & hash; // Convert to 32-bit integer
    }
    return hash >>> 0; // Ensure unsigned 32-bit integer
  }

  private xorshift(): number {
    let x = this.state;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    this.state = x >>> 0; // Ensure unsigned 32-bit integer
    return this.state;
  }

  random(): number {
    // Mix in current time for additional randomness
    const timeHash = this.hash(this.getCurrentTimeString());
    this.state ^= timeHash;
    return this.xorshift() / 4294967296; // Divide by 2^32
  }

  randomInt(min: number, max: number): number {
    return Math.floor(this.random() * (max - min) + min);
  }

  shuffle<T>(array: T[]): T[] {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = this.randomInt(0, i + 1);
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    return shuffled;
  }
}

export default SeededRandom;
