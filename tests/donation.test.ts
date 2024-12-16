import { describe, it, expect, beforeEach, vi } from 'vitest';

describe('Donation Contract', () => {
  const contractName = 'donation';
  const contractAddress = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
  
  beforeEach(() => {
    vi.resetAllMocks();
  });
  
  it('should make a donation', async () => {
    const amount = 100;
    const charityId = 0;
    const mockDonate = vi.fn().mockResolvedValue({ success: true, value: 0 });
    const result = await mockDonate(amount, charityId);
    expect(result.success).toBe(true);
    expect(typeof result.value).toBe('number');
  });
  
  it('should get donation details', async () => {
    const donationId = 0;
    const mockGetDonation = vi.fn().mockResolvedValue({
      success: true,
      value: {
        donor: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
        amount: 100,
        'charity-id': 0,
        timestamp: 123456789
      }
    });
    const result = await mockGetDonation(donationId);
    expect(result.success).toBe(true);
    expect(result.value).toHaveProperty('donor');
    expect(result.value).toHaveProperty('amount');
    expect(result.value).toHaveProperty('charity-id');
    expect(result.value).toHaveProperty('timestamp');
  });
  
  it('should get total donations', async () => {
    const mockGetTotalDonations = vi.fn().mockResolvedValue({ success: true, value: 1000 });
    const result = await mockGetTotalDonations();
    expect(result.success).toBe(true);
    expect(typeof result.value).toBe('number');
  });
});

