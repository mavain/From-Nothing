AddCSLuaFile()

SWEP.Author         = "Mavain"
SWEP.Base           = "weapon_base"
SWEP.PrintName      = "Pickaxe"
SWEP.Instructions   = "Use on the ground to collect minerals"
SWEP.BounceWeaponIcon   = false

SWEP.ViewModel      = "models/weapons/c_crowbar.mdl"
SWEP.ViewModelFlip  = false
SWEP.UseHands       = true
SWEP.WorldModel     = "models/weapons/w_crowbar.mdl"
SWEP.SetHoldType    = "melee"

SWEP.Weight         = 5
SWEP.AutoSwitchTo   = true
SWEP.AutoSwitchFrom = false

SWEP.Slot       = 0
SWEP.SlotPos    = 0

SWEP.DrawAmmo       = false
SWEP.DrawCrosshair  = true

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Ammo           = "none"
SWEP.Primary.Delay          = 0.01

SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo         = "none"

function SWEP:Initialize()
    self:SetWeaponHoldType("melee")
    self:SetHoldType("melee")
end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    self.Owner:SetNWInt("Minerals", self.Owner:GetNWInt("Minerals") + 1)

    self.Weapon:SendWeaponAnim(ACT_VM_SWINGHARD)
    LocalPlayer():SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()

end