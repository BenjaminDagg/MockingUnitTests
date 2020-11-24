using System;
using System.Threading;
using System.Threading.Tasks;
using CentroLink.MachineSetupModule.Models;
using Framework.WPF.Modules.CaliburnMicro;
using Framework.WPF.ScreenManagement;
using Framework.WPF.ScreenManagement.Prompt;

namespace CentroLink.MachineSetupModule.ViewModels
{
    /// <summary>
    /// Base class used by Add/Edit/Duplicate view models for common functionality
    /// </summary>
    public class MachineSetupAddEditDuplicateBase : ExtendedScreenBase
    {
        private MachineSetupDetailControlViewModel _detailControlViewModel;

        /// <summary>
        /// Gets or sets the add view model. This is a sub view that displays the details of the vm model
        /// </summary>
        public MachineSetupDetailControlViewModel DetailControlViewModel
        {
            get => _detailControlViewModel;
            set
            {
                _detailControlViewModel = value;
                NotifyOfPropertyChange(nameof(DetailControlViewModel));
            }
        }

        
        protected MachineSetupAddEditDuplicateBase(IScreenServices services)
            : base(services)
        {
           
        }

        /// <summary>
        /// Adds the game.
        /// </summary>
        public async void AddGame()
        {
            await DetailControlViewModel.AddGame();
        }

        /// <summary>
        /// Removes the game.
        /// </summary>
        /// <param name="selectedGameToRemove">The selected game to remove.</param>
        public virtual void RemoveGame(GameBankSetupValidationModel selectedGameToRemove)
        {
            DetailControlViewModel.RemoveGame(selectedGameToRemove);
        }

        /// <summary>
        /// Called when [game selection changed action].
        /// </summary>
        /// <param name="selected">The selected.</param>
        public virtual void OnGameSelectionChangedAction(GameBankSetupValidationModel selected)
        {
            DetailControlViewModel.OnGameSelectionChangedAction();
        }

        /// <summary>
        /// Backs to machine setup without prompt.
        /// </summary>
        public void BackToMachineSetupWithoutPrompt()
        {
            Back();
        }

        /// <summary>
        /// Handles going back to the machine setup and prompting the user to confirm
        /// </summary>
        public async void BackToMachineSetup()
        {
            var message = "Are you sure you want to go back to Machine Setup?"
                          + Environment.NewLine + "Unsaved changes will be lost.";

            var result = await PromptUserAsync(message, "Confirm Action", PromptOptions.YesNo, PromptTypes.Question);

            if (result == PromptOptions.Yes)
            {
                base.Back();
            }
        }

        protected override async Task OnDeactivateAsync(bool close, CancellationToken cancellationToken)
        {
            //prevent memory leak due to event subscriptions on DetailControlViewModel
            if (DetailControlViewModel != null)
            {
                await DetailControlViewModel.TryCloseAsync();
                DetailControlViewModel.Dispose();
            }

            await base.OnDeactivateAsync(close, cancellationToken);
        }

    }
}